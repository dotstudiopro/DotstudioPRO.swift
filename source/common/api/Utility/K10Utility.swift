//
//  K10Utility.swift
//  DotstudioPRO
//
//  Created by ketan on 27/10/15.
//  Copyright © 2015 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit

//extension Response {
//    /// The textual representation used when written to an output stream, which includes whether the result was a
//    /// success or failure.
//    public var responseJson: [String: AnyObject]! {
//        get {
////            return objc_getAssociatedObject(self, &xoAssociationKey) as? PFObject
//            
//        }
//    }
//    
//}



open class K10Utility: NSObject {


    open class func getRandomNumbers(_ totalNos: Int, fromAvailableTotalNos: Int) -> [Int] {
        var availableTotalNos: [Int] = []
        for i in 0...(fromAvailableTotalNos-1) {
            availableTotalNos.append(i)
        }

        var randomNos: [Int] = []
        while (randomNos.count != totalNos && availableTotalNos.count>0) {
            if let newRandomItem = availableTotalNos.randomItem() {
                if let indexOfNewItem = availableTotalNos.index(of: newRandomItem) {
                    availableTotalNos.remove(at: indexOfNewItem)
                    randomNos.append(newRandomItem)
                }
            }
        }
        return randomNos
    }
    
    open class func colorFor(_ startColor: UIColor, endColor: UIColor, position: Int, totalNos: Int) -> UIColor {
        var rStart: CGFloat = 0.0, gStart: CGFloat = 0.0, bStart: CGFloat = 0.0, aStart: CGFloat = 0.0
        var rEnd: CGFloat = 0.0, gEnd: CGFloat = 0.0, bEnd: CGFloat = 0.0, aEnd: CGFloat = 0.0
        
        startColor.getRed(&rStart, green: &gStart, blue: &bStart, alpha: &aStart)
        endColor.getRed(&rEnd, green: &gEnd, blue: &bEnd, alpha: &aEnd)
        
        let rIncr = (rEnd - rStart) / CGFloat(totalNos)
        let gIncr = (gEnd - gStart) / CGFloat(totalNos)
        let bIncr = (bEnd - bStart) / CGFloat(totalNos)
        let aIncr = (aEnd - aStart) / CGFloat(totalNos)
        let newColor = UIColor(red: rStart + rIncr * CGFloat(position),
                green: gStart + gIncr * CGFloat(position),
                blue: bStart + bIncr * CGFloat(position),
                alpha: aStart + aIncr * CGFloat(position))
        
        return newColor
    }

    open class func addConstraint(_ subView: UIView, superView: UIView) {
        // Width constraint, half of parent view width
        superView.addConstraints([
            NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0)
            
            ])
    }
    
    open class func toAnalyticsJsonDateString(_ date: Date) -> String {
        
        //YYYY-MM-DDTHH:MM:SS-HH:MM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent//NSTimeZone(name: "UTC")
        let strDate = dateFormatter.string(from: date)
//        print(strDate)
        return strDate
    }
    
    


    
    class func completeUrlFor(_ strurl: String) -> String {
        if strurl.hasPrefix("http") {
            return strurl
        } else {
            if strurl.hasPrefix("//") {
                return "https:".appending(strurl)
            } else {
                return "https://".appending(strurl)
            }
        }
    }
    
    open class func getRandomAtTagCb() -> Int {
        let iFinalRandom = Randoms.randomInt(100000000, 999999999)
        
//        let timeIntervalSince1970InMiliseconds = Date().timeIntervalSince1970 * 1000
//        let randomDouble = (Randoms.randomCGFloat(0, 1) * 10000) + 1
//        let roundedRandom = randomDouble.rounded(.towardZero)
//        let finalRandom = CGFloat(timeIntervalSince1970InMiliseconds) * roundedRandom
//        let iFinalRandom = Int(finalRandom)
        return iFinalRandom
    }
    

}

