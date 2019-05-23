//
//  SPLTLoginViewController.swift
//  DotstudioUI-tvOS
//
//  Created by primesoft on 08/05/18.
//

import UIKit
//import FBSDKTVOSKit


protocol SPLTLoginViewControllerDelegate {
    func didLoginWithLoginViewController()
    func didSkipWithLoginViewController()
}
open class SPLTLoginViewController: SPLTBaseViewController, UITextFieldDelegate {
    var delegate: SPLTLoginViewControllerDelegate?
    var alert: UIAlertController?
    
    @IBOutlet weak open var scrollView: UIScrollView?
    @IBOutlet weak open var constraintScrollViewBottom: NSLayoutConstraint?
    @IBOutlet weak open var textFieldEmailId: UITextField?
    @IBOutlet weak open var textFieldPassword: UITextField?
    @IBOutlet weak open var buttonLogin: UIButton?
    @IBOutlet weak open var buttonSkip: UIButton?
//    @IBOutlet weak open var fbDeviceLoginButton: FBSDKDeviceLoginButton?

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   open override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter().removeObserver(self)
    }
   
    //MARK: - IBAction methods
    
    @IBAction public func didLogin(_ sender: AnyObject) {
        self.doLogin()
    }
    
    @IBAction func didForgetPassword(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    open func doLogin() {
        self.showProgress()
        SPLTAuth0LoginUtility.sharedInstance.loginWith(self.textFieldEmailId!.text!, strPassword: self.textFieldPassword!.text!, completion: { (bSuccess) in
            // success
            self.hideProgress()
            self.gotoMainScreenAfterLogin()
        }) { (error) in
            //error
            self.hideProgress()
            self.showLoginErrorMessage()
        }
    }
    
    //MARK: - TOBE moved to DSLoginViewController
    open func doFacebookLogin(_ result: AnyObject) {
//        self.showProgress()
//        SPLTLAuth0LoginUtility.sharedInstance.loginWithFaceBookAccessToken(FBSDKAccessToken.current().tokenString, completion: { (bSuccess) in
//            self.hideProgress()
//            self.dismiss(animated: false) {
//                self.gotoMainScreenAfterLogin()
//            }
//        }) { (error) in
//            self.hideProgress()
//            self.showLoginErrorMessage()
//        }
    }
    
    open func showLoginErrorMessage() {
        let alert = UIAlertController(title: "Login faild", message: "Please check your credentials.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction open func didClickSkipButton(_ sender: AnyObject) {
        self.gotoMainScreenAfterLogin()
    }
    
   open func gotoMainScreenAfterLogin() {
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldEmailId == textField {
            self.textFieldPassword?.becomeFirstResponder()
        } else if self.textFieldPassword == textField {
            self.doLogin()
        }
        return true
    }
}

//MARK: - TOBE moved to DSLoginViewController
//MARK: - extension FBSDKDeviceLoginButton
//extension SPLTLoginViewController: FBSDKDeviceLoginButtonDelegate {
//    open func deviceLoginButtonDidCancel(_ button: FBSDKDeviceLoginButton) {
//    }
//
//    open func deviceLoginButtonDidFail(_ button: FBSDKDeviceLoginButton, error: Error) {
//    }
//
//    open func deviceLoginButtonDidLog(in button: FBSDKDeviceLoginButton) {
//        // did Login
//        if ((FBSDKAccessToken.current()) != nil) {
//            let parameters = ["fields": "email,first_name,last_name"]
//            FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (FBSDKGraphRequestConnection, result, error) -> Void in
//                self.doFacebookLogin(result as AnyObject)
//            })
//        }
//    }
//
//    open func deviceLoginButtonDidLogOut(_ button: FBSDKDeviceLoginButton) {
//    }
//}
