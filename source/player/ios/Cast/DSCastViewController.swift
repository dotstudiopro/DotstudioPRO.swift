//
//  DSCastViewController.swift
//  DSPPlayerViewController
//
//  Created by Anwar Hussain  on 29/04/19.
//

import UIKit
import GoogleCast
import AVKit
import AVFoundation

protocol DSCastViewControllerDelegate {
    func didSelectCastDevice(castDevice: DSCastDeviceModel)
    func didCancelSelectingCast()
}

class DSCastViewController: UIViewController {

    var delegate: DSCastViewControllerDelegate?
    @IBOutlet weak var tblView: UITableView!
//    var selectedVideo:SPLTVideo?
    
    var castDevices: [DSCastDeviceModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.sectionHeaderHeight = 0.0
        self.tblView.sectionFooterHeight = 0.0

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceListUpdated(notification:)),
                                               name: Notification.Name.deviceListUpdated,
                                               object: nil)
        self.reloadData()
    }
    
    @objc func deviceListUpdated(notification _: Notification) {
        self.reloadData()
    }
    func reloadData() {
        print("device list updated")
        self.castDevices = DSCastUtility.shared.getMainDeviceList()
        self.tblView.reloadData()
    }
    
    @IBAction func didClickCancelButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.delegate?.didCancelSelectingCast()
    }
    
    class open func getCastViewController() -> DSCastViewController? {
        
        let storyboard = UIStoryboard(name:"DSPPlayerViewController", bundle:Bundle(for:self))
        let vc = storyboard.instantiateViewController(withIdentifier: "DSCastViewController")
        if let castController = vc as? DSCastViewController {
            return castController
        }
        return nil
        
    }

}

extension DSCastViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.castDevices.count//self.deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let castDevice = self.castDevices[indexPath.row]
        if castDevice.castDevicePlatform == .apple {
            //self.loadAirPlayView(onCell: cell)
            if #available(iOS 11.0, *) {
                let airPlayView = DSAirPlayCastUtility.shared.loadAVPickerView(view: cell!)
//                airPlayView.delegate = self
                cell?.contentView.addSubview(airPlayView)
            } else {
                // Fallback on earlier versions
            }
        }
        if let castImageName = castDevice.castImageName {
            cell?.imageView?.image = UIImage(named: castImageName)
        }
        cell?.textLabel?.text = castDevice.castDeviceFriendlyName
        return cell!
    }
    
//    func loadAirPlayView(onCell cell:UITableViewCell?) {
//        let airPlayView = AVRoutePickerView()
//        airPlayView.delegate = self
//        airPlayView.frame.size = (cell?.contentView.bounds.size)!
//        cell?.contentView.addSubview(airPlayView)
//        for (_,button) in (airPlayView.subviews.filter{$0 is UIButton}).enumerated(){
//            let airplaybutton = button as! UIButton
//            airplaybutton.isHidden = true
//        }
//    }
}

extension DSCastViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let castDevice = self.castDevices[indexPath.row]
//        self.dismiss(animated: true, completion: nil)
        self.delegate?.didSelectCastDevice(castDevice: castDevice)
//        if castDevice.castDevicePlatform == Constants.kChromeCast {
//            print(DSChromeCastUtility.shared.sessionManager.connectionState.rawValue)
//            if DSChromeCastUtility.shared.sessionManager.connectionState.rawValue == 2 {
//                DSCastUtility.shared.PlayConnectedCastVideo(video: self.selectedVideo!, onVC: self)
//            }else{
//                let gckObj = castDevice.deviceObject as! GCKDevice
//                DSChromeCastUtility.shared.sessionManager.startSession(with: gckObj)
//            }
//        }
    }
}


// Mark: AVRoutePickerViewDelegate
//@available(iOS 11.0, *)
//extension DSCastViewController: AVRoutePickerViewDelegate{
//    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
//        print("picker will begin preesntingroutes")
//    }
//    
//    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
//        print("picker end preesntingroutes")
//        
//        if DSAirPlayCastUtility.shared.isAirPlayConnected == true {
//           DSAirPlayCastUtility.shared.avPlayerWithExternalPlayback(onViewController: self)
//        }
//    }
//}
