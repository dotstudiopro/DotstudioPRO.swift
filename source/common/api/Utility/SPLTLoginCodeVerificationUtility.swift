//
//  SPLTLoginUtility.swift
//  RevryApp-tvOS
//
//  Created by Anwer on 6/12/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import UIKit

open class SPLTLoginCodeVerificationUtility {
    public static let sharedInstance = SPLTLoginCodeVerificationUtility()
    open var isVerificationComplete = false
    open var timer:Timer?
    public init() {
    }
    
    open func resetVerification() {
        self.isVerificationComplete = false
    }
    @objc open func checkCodeVerificationStatus(_ verificationCode: String,  completion: @escaping (_ bVerificationSuccess: Bool) -> Void) {
        SPLTLoginVerificationAPI().verifyDeviceLoginCode(verificationCode, completion: {(bVerificationSuccess) in
            if bVerificationSuccess == true {
                if self.isVerificationComplete == false {
                    completion(bVerificationSuccess)
                    self.isVerificationComplete = true
                }
                return
            }
        }) {(error) in
            print(error)
            // Need to handled the faild senario if customer id is not linked
        }
        
        if self.isVerificationComplete == false {
            self.sheduleCheckCodeVerificationStatus(verificationCode, completion: completion)
        }
    }
    
    open func cancelVerification() {
        self.isVerificationComplete = true
    }
    
    open func sheduleCheckCodeVerificationStatus(_ verificationCode: String,  completion: @escaping (_ bVerificationSuccess: Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // in 10 seconds delay...
            self.checkCodeVerificationStatus(verificationCode, completion: completion)
        }
    }
    
}
