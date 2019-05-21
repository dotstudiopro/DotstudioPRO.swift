//
//  UIImageView+Extension.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import Foundation
import UIKit
//import Haneke
import AlamofireImage

public struct SPLTImageFormat<T> {
    public let name: String
    
    public let diskCapacity : UInt64
    
    public var transform : ((T) -> (T))?
    
    public var convertToData : ((T) -> Data)?
    
    public init(name: String, diskCapacity : UInt64 = UINT64_MAX, transform: ((T) -> (T))? = nil) {
        self.name = name
        self.diskCapacity = diskCapacity
        self.transform = transform
    }
    
    public func apply(_ value : T) -> T {
        var transformed = value
        if let transform = self.transform {
            transformed = transform(value)
        }
        return transformed
    }
    
    var isIdentity : Bool {
        return self.transform == nil
    }
}
public extension UIImageView {
    func splt_setImageFromURL(_ url: URL, placeholder: UIImage?) {
//        self.hnk_setImageFromURL(url, placeholder: placeholder)
        self.af_setImage(withURL: url, placeholderImage: placeholder)

    }
    
    func splt_setImageFromURL(_ url: URL) {
//        self.hnk_setImageFromURL(url)
        self.af_setImage(withURL: url)
    }

    func splt_setImageFromURL(_ url: URL, placeholder: UIImage?, format: SPLTImageFormat<UIImage>?, failure fail: ((Error?) -> ())?, success succeed: ((UIImage) -> ())?) {
//        self.af_setImage(withURL: url, placeholderImage: placeholder, filter: nil, progress: nil, progressQueue: <#T##DispatchQueue#>, imageTransition: <#T##UIImageView.ImageTransition#>, runImageTransitionIfCached: <#T##Bool#>, completion: <#T##((DataResponse<UIImage>) -> Void)?##((DataResponse<UIImage>) -> Void)?##(DataResponse<UIImage>) -> Void#>)
    
        self.af_setImage(withURL: url, placeholderImage: placeholder, filter: nil, imageTransition: .noTransition) { (response) in
            self.af_setImage(withURL: url, placeholderImage: placeholder)
        }
//        self.af_setImageWithURL(URL, placeholderImage: UIImage(named: "placeholder"), filter: nil, imageTransition: .None, completion: { (response) -> Void in
//
//        })
        
    }
    
    
//    public func splt_setImageFromURL(_ url: URL, placeholder: UIImage?, format: Haneke.Format<UIImage>?, failure fail: ((Error?) -> ())?, success succeed: ((UIImage) -> ())?) {
////        self.hnk_setImageFromURL(url, placeholder: placeholder, format: format, failure: fail, success: succeed)
//        self.af_setImage(withURL: url, placeholderImage: placeholder)
//    }
}
