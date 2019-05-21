//
//  DSCastButton.swift
//  SampleCastApp
//
//  Created by Anwar Hussain  on 23/04/19.
//  Copyright © 2019 Anwar Hussain . All rights reserved.
//

import UIKit

@IBDesignable
class DSCastButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
        //self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }

    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @objc func onPress() {
        print("Pressed")
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "CastDeviceListViewController") as! CastDeviceListViewController
//        if let currentViewController = UIApplication.topViewController() {
//            //do something with rootViewController
//            currentViewController.present(vc, animated: true, completion: nil)
//        }
    }
}
