//
//  SPLTInAppPurchaseUtility.swift
//  RevryApp-iOS
//
//  Created by Anwer on 10/29/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import UIKit
import StoreKit

public enum SPLTInAppHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "You purchase has been failed! Please try again."
        }
    }
}

open class SPLTInAppPurchaseUtility: NSObject {
    
    public static let shared = SPLTInAppPurchaseUtility()

    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    open var applePriceTier = 0
    open var strVideoId : String?
    
    open var purchaseStatusBlock: ((SPLTInAppHandlerAlertType) -> Void)?
    open var fetchProductsBlock: (([SKProduct]) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    open func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    var rental_period:String = ""
    var rental_qty:String = ""
    
    open func checkAndPurchaseVideoFromItunes(spltVideo:SPLTVideo?, fromViewController:UIViewController, completion: @escaping (_ success: Bool) -> Void) {
        //check user video status
        if let strVideoId = spltVideo?.strId {
            SPLTPurchaseVideoAPI().checkVideoPurchaseStatus(strVideoId, completion: { (infoDict) in
                if let bSuccess = infoDict["success"] as? Bool, bSuccess == true {
                    if let bUnlocked = infoDict["unlocked"] as? Bool {
                        if bUnlocked == true {
                            if let strVideoUrl = infoDict["video_m3u8"] as? String {
                                spltVideo?.strVideoUrl = strVideoUrl
                                completion(bUnlocked)
                            }
                        } else {
                            if spltVideo?.paywallType == .presell {
                                
                                if let rental_start = infoDict["rental_start"] as? [String: Any] {
                                    if let rentalStartDate = rental_start["date"] as? String {
                                        if self.isDateExpired(pdate: rentalStartDate) { //rental start is in the future
                                            let alert = UIAlertController(title: spltVideo?.strTitle, message:"Stream has not yet started. It is scheduled to start at \(self.getFormatedDateWithDate(pdate: rentalStartDate)).", preferredStyle: UIAlertController.Style.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                                completion(false)
                                            }))
                                            fromViewController.present(alert, animated: true, completion: nil)
                                            return
                                        }
                                    }
                                }
                                
                                if let rental_end = infoDict["rental_end"] as? [String: Any] {
                                    if let rentalEndDate = rental_end["date"] as? String {
                                        if !self.isDateExpired(pdate: rentalEndDate) { //rental end is in the past
                                            let alert = UIAlertController(title: spltVideo?.strTitle, message:"This video stream is expired.", preferredStyle: UIAlertController.Style.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                                completion(false)
                                            }))
                                            fromViewController.present(alert, animated: true, completion: nil)
                                            return
                                        }
                                    }
                                }
                                
                                self.showPurchaseDialogWithVideo(spltVideo: spltVideo, fromViewController: fromViewController, completion: { (succes) in completion(succes) })
                            } else {
                                self.showPurchaseDialogWithVideo(spltVideo: spltVideo, fromViewController: fromViewController, completion: { (succes) in completion(succes) })
                            }
                            
                        }
                    }
                } else {
                    /*if spltVideo?.paywallType == .presell {
                        if let rental_end = infoDict["rental_end"] as? [String: Any] {
                            if let rentalEndDate = rental_end["date"] as? String {
                                if !self.isDateExpired(pdate: rentalEndDate) { //rental end is in the past
                                    let alert = UIAlertController(title: spltVideo?.strTitle, message:"This video stream is expired.", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                        completion(false)
                                    }))
                                    fromViewController.present(alert, animated: true, completion: nil)
                                    return
                                }
                            }
                        }
                        self.showPurchaseDialogWithVideo(spltVideo: spltVideo, fromViewController: fromViewController, completion: { (succes) in completion(succes) })
                    } else {*/
                        self.showPurchaseDialogWithVideo(spltVideo: spltVideo, fromViewController: fromViewController, completion: { (succes) in completion(succes) })
                    //}
                }
            }) { (error) in
                print(error)
                completion(false)
            }
        }
    }
    
    
    open func showPurchaseDialogWithVideo(spltVideo:SPLTVideo?, fromViewController:UIViewController, completion: @escaping (_ success: Bool) -> Void) {
        if let rental_period = spltVideo?.paywallDict?["rental_period"] as? String {
            self.rental_period = rental_period
        }
        if let rental_qty = spltVideo?.paywallDict?["rental_qty"] as? String {
            self.rental_qty = rental_qty
        }
        
        let alert = UIAlertController(title: spltVideo?.strTitle, message: "Do you want to purchase this stream?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.purchaseVideoFromItunes(spltVideo: spltVideo) { (success) in
                if success == true {
                    self.checkAndPurchaseVideoFromItunes(spltVideo: spltVideo, fromViewController: fromViewController, completion: { (succes) in
                        completion(succes)
                    })
                }else {
                    print("Video purchase faild from itunes.")
                    completion(false)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            print("Video purchase faild from itunes.")
            completion(false)
        }))
        fromViewController.present(alert, animated: true, completion: nil)
    }
    
    
    open func purchaseVideoFromItunes(spltVideo:SPLTVideo?, completion: @escaping (_ success: Bool) -> Void) {
        //Fetch available products
        if let applePriceTier = spltVideo?.applePriceTier {
            self.applePriceTier = applePriceTier
            self.strVideoId = spltVideo?.strId
        }
        
        SPLTInAppPurchaseUtility.shared.fetchProductsBlock = {(products) in
            if products.count > 0 {
                SPLTInAppPurchaseUtility.shared.purchaseStatusBlock = { (type) in
                    if type == .purchased {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                SPLTInAppPurchaseUtility.shared.purchaseMyProduct(index: 0)
            } else {
                completion(false)
            }
        }
        SPLTInAppPurchaseUtility.shared.fetchAvailableProducts()
    }
    
    open func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    open func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    open func fetchAvailableProducts(){
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: "tier_\(self.applePriceTier)")
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension SPLTInAppPurchaseUtility: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // MARK: - REQUEST IAP PRODUCTS
    public func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
            fetchProductsBlock?(iapProducts)
        }
        
        print(response.invalidProductIdentifiers)
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    //trans.pseudoe
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let strId = self.strVideoId {
                        self.purchaseVideoWithId(strId, receipt: self.featchInAppRecept())
                    }
                    break
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.failed)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.restored)
                    break
                    
                default: break
                }
            }
        }
    }
    
    open func purchaseVideoWithId(_ strId:String, receipt:String) {
        SPLTPurchaseVideoAPI().purchaseVideo(strId, strBase64Receipt: receipt, completion: { (infoDict) in
            print(infoDict)
            self.purchaseStatusBlock?(.purchased)
        }, completionError: { (error) in
            print(error)
        })
    }
    
    open func featchInAppRecept() -> String {
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
                if let receipt = receiptData {
                    return receipt.base64EncodedString(options: [])
                }
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
        }
        
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
            let data = try? Data(contentsOf: receiptURL) else {
                return ""
        }
        return data.base64EncodedString(options: [])
    }
    
    open func isDateExpired(pdate:String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let timezone = NSTimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone =  timezone as TimeZone
        }
        let bDate = dateFormatter.date(from: pdate)
        let currentDate = Date()
        
        if let hDate = bDate {
            if currentDate.compare(hDate) ==  .orderedAscending {
                return true
            }
        }
        return false
    }
    
    open func getFormatedDateWithDate(pdate:String) -> String {
        
        var strDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let timezone = NSTimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone =  timezone as TimeZone
        }
        let bDate = dateFormatter.date(from: pdate)
        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        localDateFormatter.timeZone = TimeZone.current
        
        if let hDate = bDate {
            strDate = localDateFormatter.string(from: hDate)
        }
        return strDate
    }
    
    
}
