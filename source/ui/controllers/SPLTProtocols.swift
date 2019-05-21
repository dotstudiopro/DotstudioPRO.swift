//
//  SPLTProtocols.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 22/05/18.
//

import Foundation
//import DotstudioAPI


public protocol SPLTIVPPresentorDelegate {
    func didCloseIVPViewController(_ spltIVPChannelViewController: SPLTIVPChannelViewController)
}

public protocol SPLTIVPPresentor {
    func openIVPViewControllerVideo(video: SPLTVideo?, in channel: SPLTChannel?, atAutoPlayIndex autoPlayIndex: Int?, spltIVPViewControllerDelegate: SPLTIVPPresentorDelegate?)
    
    func openIVPViewControllerVideo(video: SPLTVideo?, in channel: SPLTChannel?, atAutoPlayIndex autoPlayIndex: Int?, spltIVPViewControllerDelegate: SPLTIVPPresentorDelegate?, bAdsEnabled: Bool)
}





