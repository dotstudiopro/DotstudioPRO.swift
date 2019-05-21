//
//  SPLTBaseViewController.swift
//  DotstudioUI
//
//  Created by primesoft on 08/05/18.
//

import UIKit


open class SPLTBaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open var hkProgressHUD: HKProgressHUD?
//    open func showProgress() {
//        self.hkProgressHUD = HKProgressHUD.show(addedToView: self.view, animated: true)
////        DispatchQueue.main.async {
////            self.hkProgressHUD = HKProgressHUD(withView: self.view)
////            self.hkProgressHUD?.show(animated: true)
////        }
//    }
//
//    open func hideProgress() {
//        DispatchQueue.main.async {
//            self.hkProgressHUD?.hide(animated: true)
//        }
//    }
    open func showProgress() {
        if let hkProgressHUD = self.hkProgressHUD {
            hkProgressHUD.show(animated: true)
        } else {
            self.hkProgressHUD = HKProgressHUD.show(addedToView: self.view, animated: true)
        }
    }
    
    open func hideProgress() {
        DispatchQueue.main.async {
            if let hkProgressHUD = self.hkProgressHUD {
                hkProgressHUD.hide(animated: true)
                self.hkProgressHUD = nil
            }
        }
    }
}
