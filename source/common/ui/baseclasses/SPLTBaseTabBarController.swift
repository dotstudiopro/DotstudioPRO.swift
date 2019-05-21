//
//  SPLTBaseTabBarController.swift
//  DotstudioUI
//
//  Created by primesoft on 08/05/18.
//

import UIKit

open class SPLTBaseTabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open var hkProgressHUD: HKProgressHUD?
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
