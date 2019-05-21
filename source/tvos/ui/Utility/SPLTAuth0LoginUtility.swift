//
//  SPLTLAuth0LoginUtility.swift
//  DotstudioUI-tvOS
//
//  Created by primesoft on 08/05/18.
//

import UIKit
import Auth0
//import DotstudioAPI
//import FBSDKCoreKit

open class SPLTAuth0LoginUtility: NSObject {
    static public var sharedInstance = SPLTAuth0LoginUtility()
    
    open var retrievedCredentials: Credentials?
    //    private var retrievedProfile: A0UserProfile?
    //    private var sourceViewController: UIViewController?
    
    open func getCompanyIdFromAccessToken(_ strAccessToken: String) -> String? {
        do {
            let jwt = try decode(strAccessToken)
            if let strCompanyId = jwt.body["iss"] as? String {
                return strCompanyId
            } else {
                print("Company ID is not received in Login Access Token")
            }
        } catch {
            print("Something went wrong!")
            return nil
        }
        return nil
    }
    
   open func loginWith(_ strEmailId: String, strPassword: String, completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: Error) -> Void) {
        SPLTTokenAPI().getToken { (strToken) in
            if let strCompanyId = self.getCompanyIdFromAccessToken(strToken) {
                
                Auth0.authentication()
                    .login(
                        usernameOrEmail: strEmailId,
                        password: strPassword,
                        multifactorCode: "",
                        connection: "Username-Password-Authentication",
                        scope: "openid email",
                        parameters: ["c": strCompanyId]
                    )
                    .start { result in
                        switch result {
                        case .success(let credentials): //.Success(let credentials):
                            self.retrievedCredentials = credentials
                            self.fetchUserInfoWithToken(credentials.accessToken, completion: completion, completionError: completionError)
                            print("access_token: \(String(describing: credentials.accessToken))")
                        case .failure(let error): //.Failure(let error):
                            print(error)
                            completionError(error)
                        }
                }
            }
        }
        
    }
    
   open func loginWithFaceBookAccessToken(_ faceBookAccessToken: String, completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: Error) -> Void) {
        SPLTTokenAPI().getToken { (strToken) in
            if let strCompanyId = self.getCompanyIdFromAccessToken(strToken) {
                
                let strConnectionName = SPLTConfig.auth0FBconnectionName
                Auth0.authentication()
                    .loginSocial(
                        token: faceBookAccessToken,
                        connection: strConnectionName, //"facebook",
                        scope: "openid",
                        parameters: ["c": strCompanyId]
                    )
                    .start({ result in
                        switch result {
                        case .success(let credentials): //.success(let credentials):
                            self.retrievedCredentials = credentials
                            self.fetchUserInfoWithToken(credentials.accessToken, completion: completion, completionError: completionError)
                            print("access_token: \(String(describing: credentials.accessToken))")
                        case .failure(let error): //.failure(let error):
                            print(error)
                            completionError(error)
                        }
                    })
            }
        }
        
    }
    
    //MARK: -  Facebook Login with Email & Password
    
    //Step 2: Fetch the User info
   open func fetchUserInfoWithToken(_ token:String?, completion: @escaping (_ bSuccess: Bool) -> Void, completionError: (_ error: NSError) -> Void) {
        if let actualToken = token {
            Auth0.authentication().userInfo(token: actualToken)
                .start({ (result) in
                    switch result {
                    case .success(let profile): //.Success(let profile):
                        print(profile)
                        if let strClientToken = profile["spotlight"] as? String {
                            SPLTRouter.strClientToken = strClientToken
                            UserDefaults.standard.setValue(strClientToken, forKey: "strClientToken")
                            UserDefaults.standard.synchronize()
                            
                            // Login successful
//                            self.sendLoginNotificationWithUserData()
                            NotificationCenter.default.post(name: Notification.Name.SPLT_LOGIN_COMPLETED, object: nil)
                            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.login, video: nil)
                        }
                        completion(true)
                    case .failure(let error): //.Failure(let error):
                        print(error)
                        completion(false)
                    }
                })
        }
    }
    
    
    open func showMissingProfileOrTokenAlert() {
        //        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile or token", preferredStyle: .Alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //        if let sourceViewController = self.sourceViewController {
        //            sourceViewController.presentViewController(alert, animated: true, completion: nil)
        //        }
    }
    open func showMissingClientTokenAlert() {
        //        let alert = UIAlertController(title: "Error", message: "Could not retrieve client token", preferredStyle: .Alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //        if let sourceViewController = self.sourceViewController {
        //            sourceViewController.presentViewController(alert, animated: true, completion: nil)
        //        }
    }
    
    open func logoutUser() {
//        self.sendLogoutNotificationWithUserData()
        SPLTRouter.strClientToken = nil
        UserDefaults.standard.removeObject(forKey: "strClientToken")
        UserDefaults.standard.synchronize()
        
        // TOBE moved to DSLoginViewController
//        FBSDKAccessToken.setCurrent(nil)
        
        // Logout successful
        NotificationCenter.default.post(name: Notification.Name.SPLT_LOGOUT_COMPLETED, object: nil)
        
    }

//    open func sendLoginNotificationWithUserData() {
//        SPLTUserDetailAPI().getUserDetails({ (userDataDict) -> Void in
//            // User detail is received
//            NotificationCenter.default.post(name: Notification.Name.SPLT_LOGIN, object: userDataDict)
//            print(userDataDict)
//        }) { (error) -> Void in
//            // Error occured
//        }
//    }
    
//    open func sendLogoutNotificationWithUserData() {
//        SPLTUserDetailAPI().getUserDetails({ (userDataDict) -> Void in
//            // User detail is received
//            NotificationCenter.default.post(name: Notification.Name.SPLT_LOGOUT, object: userDataDict)
//            print(userDataDict)
//        }) { (error) -> Void in
//            // Error occured
//        }
//    }
}
