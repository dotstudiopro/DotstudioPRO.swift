//
//  SPLTBaseImageView.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 10/05/18.
//

import Foundation
import UIKit
import AlamofireImage

//import Haneke

open class SPLTBaseImageView: UIImageView {

    open func splt_setImageFromStrImagePath(_ strImagePath: String, width: Int, height: Int) {
        let strFinalImagePath = SPLTFullPathRouter.imagePath(strImagePath, width, height).URLString
//        self.hnk_cancelSetImage()
        if let url = URL(string: strFinalImagePath) {
            self.splt_setImageFromURL(url)
        }
    }
    open func splt_setImageFromStrImagePath(_ strImagePath: String, sizeImage: CGSize?) {
        if let sizeImage_ = sizeImage {
            let strFinalImagePath = SPLTFullPathRouter.imagePath(strImagePath, Int(sizeImage_.width), Int(sizeImage_.height)).URLString
//            self.hnk_cancelSetImage()
//            if let url = URL(string: strFinalImagePath) {
//                self.splt_setImageFromURL(url)
//            }
            self.splt_setImageFromStrImagePath(strFinalImagePath)
        } else {
            self.splt_setImageFromStrImagePath(strImagePath)
        }
    }
    
    open func splt_setImageFromStrImagePath(_ strImagePath: String) {
        let frame = self.frame
//        self.hnk_cancelSetImage()
        if let url = URL(string: strImagePath) {
            self.splt_setImageFromUrl(url)
        }
    }
    
    
    
    open func splt_setImageFromUrl(_ url: URL) {
//        self.hnk_cancelSetImage()
//        self.hnk_setImageFromURL(url)
        self.af_setImage(withURL: url)
//        imageView.af_setImage(withURL: url)

    }
}




