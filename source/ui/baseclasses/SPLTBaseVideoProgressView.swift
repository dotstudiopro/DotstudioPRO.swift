//
//  SPLTBaseProgressView.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 14/06/18.
//

import Foundation
import UIKit
//import DotstudioAPI

open class SPLTBaseVideoProgressView: UIProgressView {
    
    open var video: SPLTVideo?
    open var iProgressPointMinThreshold: Int = 30
    open var iProgressPointMaxThresholdOffset: Int = 10
    var durationContext: UInt8 = 1
    var progressPointContext: UInt8 = 2
    var isObserversAdded: Bool = false
    open func setCellVideo(_ video: SPLTVideo) {
        self.video = video
        self.updateUI()
        if self.isObserversAdded {
            self.removeObserver(self, forKeyPath: "iDuration")
            self.removeObserver(self, forKeyPath: "progressPoint")
            self.isObserversAdded = false
        }
        self.addObserver(
            self,
            forKeyPath: "iDuration",
            options: NSKeyValueObservingOptions.new,
            context: &durationContext)
        self.addObserver(
            self,
            forKeyPath: "progressPoint",
            options: NSKeyValueObservingOptions.new,
            context: &progressPointContext)
        self.isObserversAdded = true
    }
    open func updateUI() {
        if let video = self.video {
            let iVideoDuration = video.iDuration
            if iVideoDuration == 0 {
                self.isHidden = true
            } else {
                if let iProgressPoint = video.progressPoint, iProgressPoint > self.iProgressPointMinThreshold {
                    let fVideoDuration = Float(iVideoDuration)
                    let fProgressPoint = Float(iProgressPoint)
                    let fProgress = fProgressPoint/fVideoDuration
                    self.isHidden = false
                    self.progress = fProgress
                } else {
                    self.isHidden = true
                }
            }
        }
    }
    
    override open func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        if (context == &durationContext) {
            self.updateUI()
        } else if (context == &progressPointContext) {
            self.updateUI()
        }
    }
    
    open func clearProgress() {
        self.isHidden = true
    }

}





