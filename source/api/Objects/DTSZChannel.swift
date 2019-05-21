//
//  DTSZChannel.swift
//  DotstudioPRO
//
//  Created by ketan on 26/03/15.
//  Copyright (c) 2015 ___DotStudioz___. All rights reserved.
//

import Foundation

public protocol DTSZChannelDelegate {
    func didUpdateChannelData(_ channelDict: [String: AnyObject])
}

class DTSZChannel: NSObject { //, DTSZChannelAPIDelegate {
    
    internal var delegate: DTSZChannelDelegate?
    var categorySlug: String = ""
    var channelDict: [String: AnyObject]! {
        didSet {
            
        }
    }
    
    override init() {
        
    }
    
    init(strChannelSlug: String) {
        super.init()
        self.slug = strChannelSlug
        // Load Channel
    }
    init(strCategoryChannelSlug: String) {
        super.init()
//        self.strCategoryChannelSlug = strCategoryChannelSlug
        
        self.slug = strCategoryChannelSlug.substring(from: (strCategoryChannelSlug.range(of: "/")?.upperBound)!)
        
        
        // Load Channel
    }
    
    init(categorySlug: String, channelDict: [String: AnyObject]) {
        super.init()
        self.categorySlug = categorySlug
        self.channelDict = channelDict
        self.mapFromDictionary(channelDict)

    }
    
    var id_: String?
    var slug: String?
    var strCategoryChannelSlug: String?
    var company: String?
    var spotlight_company_id: String?
    var spotlight_poster: String?
    var link: String?
    
    var strTitle: String = ""
    var strDescription: String = ""
    var strChannelInfo: String = ""
//    var strCategory: String = ""
//    var strYear: String = ""
//    var strLanguage: String = ""
//    var strCountry: String = ""
    var strCompanyName: String = ""
    var channel_url: String?

    
    func mapFromDictionary(_ dict: [String: AnyObject]) {
        
        if let strId_ = dict["_id"] as? String {
            self.id_ = strId_
        }
        if let channel_url = dict["channel_url"] as? String {
            self.channel_url = channel_url
        }
        if let strSlug = dict["slug"] as? String {
            self.slug = strSlug
        }
        if let strCompany = dict["company"] as? String {
            self.company = strCompany
        }
        if let spotlight_company_id = dict["spotlight_company_id"] as? String {
            self.spotlight_company_id = spotlight_company_id
        }
        if let str_spotlight_poster = dict["spotlight_poster"] as? String {
            let str_final_spotlight_poster: String = SPLTFullPathRouter.imageFullPath(str_spotlight_poster).URLString
            self.spotlight_poster = str_final_spotlight_poster
        } else if let str_spotlight_poster = dict["video_thumb"] as? String {
            self.spotlight_poster = str_spotlight_poster
        }

        if let strTitle_ = dict["title"] as? String {
            self.strTitle = strTitle_
        }

        if let strLink = dict["link"] as? String {
            self.link = strLink
        }
        
        if let channelSubDict = channelDict {
//        if let channelSubDict = channelDict["channel"] as? [String: AnyObject] {
            if let strDescription_ = channelSubDict["description"] as? String {
                self.strDescription = strDescription_
            }
            self.strChannelInfo = ""
            if let strCategory: String = channelSubDict["category"] as? String {
                self.strChannelInfo = "\(strCategory) | "
            }
            if let strYear: String = channelSubDict["year"] as? String {
                self.strChannelInfo += "\(strYear) | "
            }
            if let strRating: String = channelSubDict["rating"] as? String {
                self.strChannelInfo += "\(strRating) | "
            }
            if let strLanguage: String = channelSubDict["language"] as? String {
                self.strChannelInfo += "\(strLanguage) | "
            }
            if let strCountry: String = channelSubDict["country"] as? String {
                self.strChannelInfo += "\(strCountry) | "
            }
            if let strCompany: String = channelSubDict["company"] as? String {
                self.strCompanyName = strCompany
                self.strChannelInfo += "\(strCompany.uppercased())"
            }
            
            
            if let actors: [String] = channelSubDict["actors"] as? [String] {
                self.setActors(actors)
            }
            if let writers: [String] = channelSubDict["writers"] as? [String] {
                self.setWriters(writers)
            }
            if let directors: [String] = channelSubDict["directors"] as? [String] {
                self.setDirectors(directors)
            }

            
//        }
        }
        
        



    }
    
    var strDirectors: String = ""
    var strWriters: String = ""
    var strActors: String = ""
    func setActors(_ actors: [String]) {
        var strActors: String = "Actors: "
        var i: Int = 0
        for actor in actors {
            if (i == actors.count-1) {
                strActors += "\(actor)"
            } else {
                strActors += "\(actor), "
            }
            i += 1
        }
        self.strActors = strActors
//        self.updateDirectorsWritersActors()
    }
    func setWriters(_ writers: [String]) {
        var strWriters: String = "Writers: "
        var i: Int = 0
        for writer in writers {
            if (i == writers.count-1) {
                strWriters += "\(writer)"
            } else {
                strWriters += "\(writer), "
            }
            i += 1
        }
        self.strWriters = strWriters
//        self.updateDirectorsWritersActors()
    }
    func setDirectors(_ directors: [String]) {
        var strDirectors: String = "Directors: "
        var i: Int = 0
        for director in directors {
            if (i == directors.count-1) {
                strDirectors += "\(director)"
            } else {
                strDirectors += "\(director), "
            }
            i += 1
        }
        self.strDirectors = strDirectors
//        self.updateDirectorsWritersActors()
    }
    
    func getVideoDetailAtIndex(_ index: Int) -> NSDictionary! {
//        var videoDict: NSDictionary!
        if let videoDetails = self.channelDict["videos_details"] as? NSArray {
            if let videoDict = videoDetails[index] as? NSDictionary {
//                videoDict = videoDetail
                return videoDict
            }
        }
        return nil
    }
    
    func getBlockHeight() -> Double {
        var iBlockHeight = 0.0
        iBlockHeight += 2.0 // For Video Title
        iBlockHeight += 1.0 // For Video Info
        iBlockHeight += 3.0 // For Video Description
        if (self.strDirectors != "") {
            iBlockHeight += 1.0
        }
        if (self.strActors != "") {
            iBlockHeight += 1.0
        }
        if (self.strWriters != "") {
            iBlockHeight += 1.0
        }
        return iBlockHeight
    }
 
    
    func updateChannelInfo() {
    }
    
    
    //MARK: - request channel data
    func requestChannelInfo() {
        if let slug = self.slug {
            // Always request direct channel details.
            if (self.categorySlug != "") {
                let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
                channelAPI.delegate = self
                channelAPI.getCategoryChannel(self.categorySlug, strChannelSlug: slug, completion: { (channelDict) in
                    //completion
                    }, completionError: { (error) in
                        //error
                })
            } else {
                // Request direct Channel Info without Category slug
                let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
                channelAPI.delegate = self
                channelAPI.getChannel(slug, completion: { (channelDict) in
                    // completion
                    }, completionError: { (error) in
                        //error
                })
            }
            
        } else if let strCategoryChannelSlug = self.strCategoryChannelSlug, strCategoryChannelSlug != "" {
            SPLTChannelAPI().getPurchasedCategoryChannel(strCategoryChannelSlug, completion: { (channelDict) in
                    self.channelDict = channelDict
                    self.mapFromDictionary(channelDict)
                    self.delegate?.didUpdateChannelData(channelDict)
                }, completionError: { (error) in
                    print(error)
            })
        }
    }
    
//    //MARK: - DTSZChannelAPIDelegate methods
//    func didReceiveChannelData(infoDict: [String: AnyObject]) {
//        print(infoDict)
//        if let success = infoDict["success"] as? Bool {
//            if success == true {
//                if let data = infoDict["data"] as? [String: AnyObject] {
//                    if let channels = data["channels"] as? [[String: AnyObject]] {
//                        if (channels.count>0) {
//                            let channelDict = channels[0]
//                            self.mapFromDictionary(channelDict)
//                            self.delegate?.didUpdateChannelData(channelDict)
//                        }
//                    }
//                }
//
//            }
//        }
//    }
//    func didFailedAPICall() {
////        self.delegate?.didFailedAPICall()
//    }

}



//MARK: -
//MARK: - extension SPLTChannelAPIDelegate
extension DTSZChannel: SPLTChannelAPIDelegate {
    func didReceiveChannel(_ spotlightChannel_: [String : AnyObject]) {
        self.channelDict = spotlightChannel_
        self.mapFromDictionary(spotlightChannel_)
        self.delegate?.didUpdateChannelData(spotlightChannel_)
//        if let success = spotlightChannel_["success"] as? Bool {
//            if success == true {
//                if let data = spotlightChannel_["data"] as? [String: AnyObject] {
//                    if let channels = data["channels"] as? [[String: AnyObject]] {
//                        if (channels.count>0) {
//                            let channelDict = channels[0]
//                            self.mapFromDictionary(channelDict)
//                            self.delegate?.didUpdateChannelData(channelDict)
//                        }
//                    }
//                }
//
//            }
//        }

    }
    func didFailedChannelAPICall() {
//        self.delegate?.didFailedChannelAPICall()
    }
    //    func didReceiveChannels(spotlightChannels_: [[String : AnyObject]]) {
    //        self.spotlightChannels = spotlightChannels_
    //        self.mergeSpotlightCategoriesAndChannels()
    //    }
    //    func didFailedChannelsAPICall() {
    //
    //    }
}






