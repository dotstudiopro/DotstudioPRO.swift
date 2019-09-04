//
//  SPLTVideo+extensionPlayer.swift
//  DSPPlayerViewController
//
//  Created by Ketan Sakariya on 30/08/18.
//

import Foundation

extension SPLTVideo {
    
    func getMP4Url() -> String? {
        if let strVideoUrl = self.strVideoUrl {
            let strMP4VideoUrl = strVideoUrl.replacingOccurrences(of: ".m3u8", with: ".mp4")
            return strMP4VideoUrl
        }
        return nil
    }
}




