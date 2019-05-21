//
//  SPLTIVPVideoViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

public protocol SPLTIVPVideoViewControllerDelegate {
    func didSelectVideo(_ video: SPLTVideo)
}

open class SPLTIVPVideoViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
