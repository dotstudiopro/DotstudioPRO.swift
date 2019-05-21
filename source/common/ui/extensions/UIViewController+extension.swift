//
//  UIViewController+extension.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 09/05/18.
//

import Foundation
import UIKit

extension UIViewController {
    
    open func getViewControllerFromStoryboardName(_ strStoryBoardName: String, strViewControllerIdentifier: String) -> UIViewController {
        let storyboardViewController = UIStoryboard(name: strStoryBoardName, bundle: nil)
        let viewController = storyboardViewController.instantiateViewController(withIdentifier: strViewControllerIdentifier)
        return viewController
    }
}

extension UIViewController {
    public func splt_configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView: UIView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView.addSubview(childController.view)
        self.splt_constrainViewEqual(holderView: holderView, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    
    public func splt_constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
}
