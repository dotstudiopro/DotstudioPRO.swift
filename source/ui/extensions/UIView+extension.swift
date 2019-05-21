//
//  UIView+extension.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 26/09/18.
//

import Foundation
import UIKit

public extension UIView {

    public func splt_constrainViewEqual(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal,
                                           toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal,
                                         toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal,
                                          toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
        
        self.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}





