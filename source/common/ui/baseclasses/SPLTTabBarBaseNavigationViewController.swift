//
//  SPLTTabBarBaseNavigationViewController.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 09/05/18.
//

import Foundation
import UIKit

open class SPLTTabBarBaseNavigationViewController: SPLTBaseNavigationViewController {

#if os(iOS)
    override open var prefersStatusBarHidden: Bool {
        return false
    }
#endif
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}






