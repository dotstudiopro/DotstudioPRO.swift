//
//  SPLTHorizontalBaseTableViewCell.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 10/05/18.
//

import Foundation
import UIKit


//MARK:-
//MARK:-
//MARK:- TableView Cells
public protocol SPLTHorizontalBaseTableViewCellDelegate {
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectCategory category: SPLTCategory)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectChannel channel: SPLTChannel, atIndex index: Int)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectVideo video: SPLTVideo, inChannel channel: SPLTChannel?, atIndex index: Int)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didLostFocusChannel channel: SPLTChannel, inCategory: SPLTCategory?, atIndex index: Int)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didLostFocusVideo video: SPLTVideo, inChannel channel: SPLTChannel?, inCategory: SPLTCategory?, atIndex index: Int)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didFocusChannel channel: SPLTChannel, inCategory: SPLTCategory?, atIndex index: Int)
    func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didFocusVideo video: SPLTVideo, inChannel channel: SPLTChannel?, inCategory: SPLTCategory?, atIndex index: Int)
}


open class SPLTHorizontalBaseTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open var delegate: SPLTHorizontalBaseTableViewCellDelegate?
    open var category: SPLTCategory?
    open var collectionViewItemSize:CGSize = CGSize(width: 160, height: 90)
    open var collectionViewImageSize:CGSize = CGSize(width: 160, height: 90)
    open var channel: SPLTChannel?
    
    @IBOutlet weak open var labelTitle: UILabel?
    @IBOutlet weak open var collectionView: UICollectionView?
    @IBOutlet weak open var pageControl: UIPageControl?

    override open func prepareForReuse() {
        super.prepareForReuse()
        self.category = nil
        self.channel = nil
        self.delegate = nil
        self.collectionView?.reloadData()
    }
    open func reloadData() {
        self.collectionView?.reloadData()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.resetCollectionViewSize(self.collectionViewItemSize)
    }
    
    open func loadCategory(category: SPLTCategory) {
        category.loadCategoryChannels(completion: { (dictCategoryChannel) in
            // success
            if category.channels.count > 1 {
                self.collectionView?.reloadData()
            } else if category.channels.count == 1 {
                if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                    self.loadPlaylistChannel(playlistChannel: playlistChannel)
                }
            } else {
                self.collectionView?.reloadData()
            }
        }) { (error) in
            // error
        }
    }
    
    open func loadPlaylistChannel(playlistChannel: SPLTPlaylistChannel) {
        if playlistChannel.isFullChannelLoaded {
            self.collectionView?.reloadData()
        } else {
            playlistChannel.loadFullChannel({ (channelDict) in
                // success
                self.collectionView?.reloadData()
            }) { (error) in
                //error
            }
        }
    }
    
    open func setRailCategory(category: SPLTCategory) {
        if category.channels.count > 1 {
            self.collectionView?.reloadData()
        } else if category.channels.count == 1 {
            if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                self.setRailChannel(playlistChannel: playlistChannel)
            }
        }
    }
    
    open func setRailChannel(playlistChannel: SPLTPlaylistChannel) {
        playlistChannel.loadFullChannel({ (channelDict) in
            // success
            self.collectionView?.reloadData()
        }) { (error) in
            // error
        }
    }
    
    open func setCellData(_ category: SPLTCategory, collectionViewItemSize: CGSize, collectionViewImageSize: CGSize) {
        self.collectionViewItemSize = collectionViewItemSize
        self.resetCollectionViewSize(collectionViewItemSize)
        self.collectionViewImageSize = collectionViewImageSize
        self.category = category
        self.category?.delegate = self
        self.updateUI()
    }
    
    open func setCellChannelData(_ channel: SPLTChannel, collectionViewItemSize: CGSize, collectionViewImageSize: CGSize) {
        self.collectionViewItemSize = collectionViewItemSize
        self.resetCollectionViewSize(collectionViewItemSize)
        self.collectionViewImageSize = collectionViewImageSize
        self.channel = channel
//        self.channel?.delegate = self
        self.updateUI()
    }
    
    open func updateUI() {
        if let category = self.category {
            if let strTitle = category.strName {
                self.labelTitle?.text = strTitle
            }
            if category.channels.count > 1 {
                self.collectionView?.reloadData()
            } else if category.channels.count == 1 {
                let channel = category.channels[0]
                self.updateChannelUI(channel: channel)
            }
            self.updatePageIndicatorUI()
        } else if let channel = self.channel {
            if let strTitle = channel.strTitle {
                self.labelTitle?.text = strTitle
            }
            self.updateChannelUI(channel: channel)
        }
    }
    
    open func updateChannelUI(channel: SPLTChannel) {
        if channel is SPLTCustomPlaylistChannel {
            self.collectionView?.reloadData()
        } else if let playlistChannel = channel as? SPLTPlaylistChannel {
            playlistChannel.loadFullChannel({ (channelDict) in
                // success
                self.collectionView?.reloadData()
                self.updatePageIndicatorUI()
            }) { (error) in
                // error
            }
        }
    }
    
    open func updatePageIndicatorUI(){
        if let category = self.category {
            if category.channels.count == 1 {
                // playlist channel...
                if let playlistChannel = category.channels.first as? SPLTPlaylistChannel {
                    self.pageControl?.numberOfPages = playlistChannel.playlistVideos.count
                    self.pageControl?.currentPage = 0
                }
            } else if category.channels.count > 1 {
                self.pageControl?.numberOfPages = category.channels.count
                self.pageControl?.currentPage = 0
            }
        } else if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            self.pageControl?.numberOfPages = playlistChannel.playlistVideos.count
            self.pageControl?.currentPage = 0
        }
    }
    
    open func resetCollectionViewSize(_ collectionViewItemSize: CGSize) {
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = collectionViewItemSize
        }
        
    }

///MARK: -
//MARK: - extension UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let category = self.category {
            if category.channels.count > 1 {
                return category.channels.count
            } else if category.channels.count == 1 {
                if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                    return playlistChannel.playlistVideos.count
                }
            }
        } else if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            return playlistChannel.playlistVideos.count
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

//MARK: -
//MARK: - extension UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let category = self.category {
            if category.channels.count > 1 {
                let channel = category.channels[indexPath.row]
                self.delegate?.spltHorizontalBaseTableViewCell(self, didSelectChannel: channel, atIndex: indexPath.row)
            } else if category.channels.count == 1 {
                if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                    if indexPath.row < playlistChannel.playlistVideos.count {
                        let video = playlistChannel.playlistVideos[indexPath.row]
                        self.delegate?.spltHorizontalBaseTableViewCell(self, didSelectVideo: video, inChannel: playlistChannel, atIndex: indexPath.row)
                    }
                }
            }
        } else if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            if indexPath.row < playlistChannel.playlistVideos.count {
                let video = playlistChannel.playlistVideos[indexPath.row]
                self.delegate?.spltHorizontalBaseTableViewCell(self, didSelectVideo: video, inChannel: playlistChannel, atIndex: indexPath.row)
            }
        }
    }
    
    #if os(tvOS)
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if #available(tvOS 10.0, *) {
            if let collectionViewCell = context.previouslyFocusedItem as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPath(for: collectionViewCell) {
                    if let category = self.category {
                        if category.channels.count > 1 {
                            if indexPath.row < category.channels.count {
                                let channel = category.channels[indexPath.row]
                                self.delegate?.spltHorizontalBaseTableViewCell(self, didLostFocusChannel: channel, inCategory: category, atIndex: indexPath.row)
                            }
                        } else {
                            if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                                if indexPath.row < playlistChannel.playlistVideos.count {
                                    let video = playlistChannel.playlistVideos[indexPath.row]
                                    self.delegate?.spltHorizontalBaseTableViewCell(self, didLostFocusVideo: video, inChannel: playlistChannel, inCategory: category, atIndex: indexPath.row)
                                }
                            }
                        }
                    }
                }
            }
            if let collectionViewCell = context.nextFocusedItem as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPath(for: collectionViewCell) {
                    if let category = self.category {
                        if category.channels.count > 1 {
                            if indexPath.row < category.channels.count {
                                let channel = category.channels[indexPath.row]
                                self.delegate?.spltHorizontalBaseTableViewCell(self, didFocusChannel: channel, inCategory: category, atIndex: indexPath.row)
                            }
                        } else {
                            if let playlistChannel = category.channels[0] as? SPLTPlaylistChannel {
                                if indexPath.row < playlistChannel.playlistVideos.count {
                                    let video = playlistChannel.playlistVideos[indexPath.row]
                                    self.delegate?.spltHorizontalBaseTableViewCell(self, didFocusVideo: video, inChannel: playlistChannel, inCategory: category, atIndex: indexPath.row)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    #endif
}

//MARK: -
//MARK: - extension SPLTCategoryDelegate
extension SPLTHorizontalBaseTableViewCell: SPLTCategoryDelegate {
    public func didUpdateCategoryChannels() {
        
    }
    
    public func didUpdateCategoryChannelsForCategory(_ category: SPLTCategory) {
        self.updateUI()
    }
}







