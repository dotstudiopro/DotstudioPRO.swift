//
//  SPLTIVPPlayerViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit

public protocol SPLTIVPPlayerViewControllerDelegate {
    func didFinishPlayingVideoOnTVOSPlayerViewController(_ tvosPlayerViewController: SPLTIVPPlayerViewController)
}

open class SPLTIVPPlayerViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
