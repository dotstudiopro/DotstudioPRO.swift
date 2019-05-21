//
//  DSCastUtility.swift
//  SampleCastApp
//
//  Created by Anwar Hussain  on 23/04/19.
//  Copyright © 2019 Anwar Hussain . All rights reserved.
//

import Foundation
import GoogleCast

protocol DSCastUtilityDelegate {
    //func didDiscoverCastDevice()
    //func didStopShowingCastDevice()
    
    func didConnectedToCastDevice()
    func didDisconnectedFromCastDevice()
    func didCancelPlayingCastVideo()
    
    func didStartPlayingCastVideo()
    func didStopPlayingCastVideo()
    func didRequestMediaPlay()
    func didRequestMediaPause()
}

protocol DSBaseCastUtility {
    //func initialize()
    func playCastVideo()
    func initializeWithDelegate(delegate:DSCastUtility)
    func stopCasting(video: SPLTVideo?, fromViewController viewController: UIViewController?)
    
}

protocol DSBaseCastUtilityDelegate {
    //func didConnectedToCastDevice(baseCastUtility: DSBaseCastUtility, deviceModel: DeviceModel)
    //func didDisconnectedFromCastDevice(baseCastUtility: DSBaseCastUtility, deviceModel: DeviceModel)
    
    func didDiscoverCastDevice(baseCastUtility: DSBaseCastUtility, scannedDeviceList: [DSCastDeviceModel])
    
    func didConnectedToCastDevice(baseCastUtility: DSBaseCastUtility)
    func didDisconnectedFromCastDevice(baseCastUtility: DSBaseCastUtility)
    
    func didStartPlayingCastVideo(castDeviceModel: DSCastDeviceModel?)
    func didStopPlayingCastVideo()
    func didRequestMediaPlay()
    func didRequestMediaPause()
}

enum DSPConnectedCastDeviceType {
    case apple
    case chromeCast
    case none
}

/*
 This class will combine all cast utility devices & show it on View Controller. It also initializes all sub utilities.
 */
class DSCastUtility:NSObject {
    static let shared = DSCastUtility()
    var mainDeviceList = [DSCastDeviceModel]()
    var delegate: DSCastUtilityDelegate?
    var baseCastDelegate:DSBaseCastUtility?
    var connectedDeviceType:String?
//    var castDeviceType: DSPConnectedCastDeviceType = .none
    var castUtilities: [DSBaseCastUtility] = []
    var video: SPLTVideo?
    var viewController: UIViewController?
    var curCastDeviceModel: DSCastDeviceModel?
    var castViewcontroller: DSCastViewController?
    var isCasting: Bool = false

    override init(){
        super.init()
        
        if #available(iOS 11.0, *) {
            DSAirPlayCastUtility.shared.delegate = self
            self.castUtilities.append(DSAirPlayCastUtility.shared)
        } else {
            // Fallback on earlier versions
        }
        DSChromeCastUtility.shared.delegate = self
        self.castUtilities.append(DSChromeCastUtility.shared)
    }
    
    func initialize(withDelegate: DSCastUtilityDelegate) {
        for castUtility in self.castUtilities {
            //castUtility.initialize()
            castUtility.initializeWithDelegate(delegate: self)
        }
       
//        DSAirPlayCastUtility.shared.initialize()
//        DSChromeCastUtility.shared.initialize()
        self.delegate = withDelegate
    }
    

    func getMainDeviceList() -> [DSCastDeviceModel] {
        return self.mainDeviceList
//         self.mainDeviceList.removeAll()
//        let deviceModelObj = DSCastDeviceModel(castDevicePlatform: Constants.kApple, castDeviceFriendlyName: "AirPlay & Bluetooth", deviceObject: nil, castImageName: "airplay_logo" )
//        self.mainDeviceList.append(deviceModelObj)
//        self.mainDeviceList += DSChromeCastUtility.shared.chromeCastDeviceList
//        return self.mainDeviceList
    }
    
    func addScannedDevices(scannedDeviceList:[DSCastDeviceModel]) {
        self.mainDeviceList.removeAll()
        if #available(iOS 11.0, *) {
            self.mainDeviceList.append(DSAirPlayCastUtility.shared.airplayCastDeviceModel)
        } else {
            // Fallback on earlier versions
        }
        self.mainDeviceList += scannedDeviceList
    }
    
    func onClickCastVideo(video: SPLTVideo, fromViewController viewController: UIViewController) {
        self.viewController = viewController
        if self.isCasting == false {
            self.video = video
            guard let castViewcontroller = DSCastViewController.getCastViewController() else { return  }
            self.castViewcontroller = castViewcontroller
            castViewcontroller.delegate = self
            castViewcontroller.modalPresentationStyle = .overCurrentContext
            viewController.show(castViewcontroller, sender: self)
//            self.isCasting = true
        } else {
//            self.stopCasting()
        }
    }
    func dismissCastViewController() {
        self.castViewcontroller?.dismiss(animated: true, completion: nil)
        self.castViewcontroller = nil
    }
    func playConnectedCastVideo(video: SPLTVideo, onDevice castDeviceModel: DSCastDeviceModel) {
        guard let viewController = self.viewController else {
            return
        }
        switch castDeviceModel.castDevicePlatform {
            case .apple:
                print("apple cast")
                if #available(iOS 11.0, *) {
                    DSAirPlayCastUtility.shared.playConnectedCastVideo(video: video, onDevice: castDeviceModel, onViewController: viewController)
                } else {
                    // Fallback on earlier versions
            }
            case .chromeCast:
                DSChromeCastUtility.shared.playConnectedCastVideo(video: video, onDevice: castDeviceModel)
            case .none:
                print("default")
        }
    }
    
    func stopCasting(video: SPLTVideo?, fromViewController viewController: UIViewController?){
        guard let curCastDeviceModel = self.curCastDeviceModel else {
            return
        }
        switch curCastDeviceModel.castDevicePlatform {
        case .apple:
            if #available(iOS 11.0, *) {
                DSAirPlayCastUtility.shared.stopCasting(video: video, fromViewController: viewController)
//                self.isCasting = false
            } else {
                // Fallback on earlier versions
            }
            break
        case .chromeCast:
            DSChromeCastUtility.shared.stopCasting(video: video, fromViewController: viewController)
//            self.isCasting = false
            break
        default:
            break
        }
    }
}

extension DSCastUtility: DSBaseCastUtilityDelegate {
    func didDiscoverCastDevice(baseCastUtility: DSBaseCastUtility, scannedDeviceList: [DSCastDeviceModel]) {
        self.addScannedDevices(scannedDeviceList: scannedDeviceList)
        NotificationCenter.default.post(name:.deviceListUpdated, object: nil)
    }
    
    func didConnectedToCastDevice(baseCastUtility: DSBaseCastUtility) {
//        self.castDeviceType = .chromeCast
        self.delegate?.didConnectedToCastDevice()
    }
    
    func didDisconnectedFromCastDevice(baseCastUtility: DSBaseCastUtility) {
        self.delegate?.didDisconnectedFromCastDevice()
    }
    func didStartPlayingCastVideo(castDeviceModel: DSCastDeviceModel?) {
        self.curCastDeviceModel = castDeviceModel
        self.isCasting = true
        DispatchQueue.main.async {
            self.dismissCastViewController()
            self.delegate?.didStartPlayingCastVideo()
        }
    }
    func didStopPlayingCastVideo() {
        self.isCasting = false
        DispatchQueue.main.async {
            self.delegate?.didStopPlayingCastVideo()
        }
    }
    func didRequestMediaPlay() {
        DispatchQueue.main.async {
            self.delegate?.didRequestMediaPlay()
        }
    }
    func didRequestMediaPause() {
        DispatchQueue.main.async {
            self.delegate?.didRequestMediaPause()
        }
    }
}


extension DSCastUtility: DSCastViewControllerDelegate {
    func didCancelSelectingCast() {
//        self.isCasting = false
        self.delegate?.didCancelPlayingCastVideo()
        self.dismissCastViewController()
    }
    
    func didSelectCastDevice(castDevice: DSCastDeviceModel) {
        if let video = self.video {
            self.playConnectedCastVideo(video: video, onDevice: castDevice)
        }
        
        self.dismissCastViewController()
        
//        if castDevice.castDevicePlatform == Constants.kChromeCast {
//            print(DSChromeCastUtility.shared.sessionManager.connectionState.rawValue)
//            if DSChromeCastUtility.shared.sessionManager.connectionState.rawValue == 2 {
//                self.PlayConnectedCastVideo(video: self.selectedVideo!, onVC: self)
//            }else{
//                let gckObj = castDevice.deviceObject as! GCKDevice
//                DSChromeCastUtility.shared.sessionManager.startSession(with: gckObj)
//            }
//        }
    }
}
