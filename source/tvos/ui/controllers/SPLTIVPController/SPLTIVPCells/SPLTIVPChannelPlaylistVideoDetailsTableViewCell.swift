//
//  SPLTIVPChannelPlaylistVideoDetailsTableViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit


public protocol SPLTIVPChannelPlaylistVideoDetailsTableViewCellDelegate {
    func didHighlightVideoAtIndex(_ video: SPLTVideo, index: Int)
    func didSelectVideoAtIndex(_ video: SPLTVideo, index: Int, tvosChannelPlaylistVideoDetailsTableViewCell: SPLTIVPChannelPlaylistVideoDetailsTableViewCell)
    func didLoadedChannelVideosForPlaylistVideoDetailsTableViewCell(_ channel: SPLTChannel)
}

open class SPLTIVPChannelPlaylistVideoDetailsTableViewCell: UITableViewCell {

    open var autoPlayIndex: Int?
    open var channel: SPLTChannel? {
        didSet {
            if let channel = self.channel {
                self.requestFullChannel(channel)
            }
            self.updateUI()
            self.collectionView?.reloadData()
        }
    }

    open var delegate: SPLTIVPChannelPlaylistVideoDetailsTableViewCellDelegate?
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var collectionView: UICollectionView?
    
    open override var preferredFocusedView: UIView? {
        return self.collectionView
    }
    
    open override var canBecomeFocused: Bool {
        return false
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
//        self.collectionView?.register(UINib(nibName: "DSIVPChannelPlaylistVideoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPLTIVPChannelPlaylistVideoDetailCollectionViewCell")

        self.labelTitle?.text = ""
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.resetCollectionViewLayoutItemSize()
    }
    
    open func resetCollectionViewLayoutItemSize() {
        if (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout) != nil {
           // if let itemSize = SPLTThemeConfig.itemSizeForIVPChannelRailCollectionView {
             //   flowLayout.itemSize = itemSize
            //}
        }
    }
    
    open func updateUI() {
        
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel, spltMultiLevelChannel.iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
            let curChildChannel = spltMultiLevelChannel.childChannels[spltMultiLevelChannel.iCurChildChannelIndex]
            self.labelTitle?.text = curChildChannel.strTitle
        } else if let channel = self.channel {
            self.labelTitle?.text = channel.strTitle
        }
        
    }
    
    open func requestFullChannel(_ channel: SPLTChannel) {
        //for (index,childChannel) in spltMultiLevelChannel.childChannels.enumerated() {
        if !channel.isFullChannelLoaded {
            channel.loadFullChannel({ (dictChildChannel) in
                // loaded child channel.
                self.updateUI()
                self.collectionView?.reloadData()
                self.delegate?.didLoadedChannelVideosForPlaylistVideoDetailsTableViewCell(channel)
            }, completionError: { (error) in
                // Error while loading child channel
            })
        }
    }
    
}

//MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTIVPChannelPlaylistVideoDetailsTableViewCell: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if let autoPlayIndex = self.autoPlayIndex {
            return IndexPath(row: autoPlayIndex, section: 0)
        }
        return nil
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            return playlistChannel.playlistVideos.count
        } else if let videoChannel = self.channel as? SPLTVideoChannel {
            return 1
        }
        return 0
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tvosChannelPlaylistVideoDetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPLTIVPChannelPlaylistVideoDetailCollectionViewCell", for: indexPath) as! SPLTIVPChannelPlaylistVideoDetailCollectionViewCell
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            tvosChannelPlaylistVideoDetailCollectionViewCell.video = playlistChannel.playlistVideos[indexPath.row]
        } else if let videoChannel = self.channel as? SPLTVideoChannel {
            if let video = videoChannel.video {
                tvosChannelPlaylistVideoDetailCollectionViewCell.video = video
            }
        }
        return tvosChannelPlaylistVideoDetailCollectionViewCell
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegate
extension SPLTIVPChannelPlaylistVideoDetailsTableViewCell: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let currentFocusedIndexPath = context.nextFocusedIndexPath {
            if let playlistChannel = self.channel as? SPLTPlaylistChannel {
                let video = playlistChannel.playlistVideos[currentFocusedIndexPath.row]
                self.delegate?.didHighlightVideoAtIndex(video, index: currentFocusedIndexPath.row)
            } else if let videoChannel = self.channel as? SPLTVideoChannel {
                if let video = videoChannel.video {
                    self.delegate?.didHighlightVideoAtIndex(video, index: currentFocusedIndexPath.row)
                }
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            let video = playlistChannel.playlistVideos[indexPath.row]
        //            self.delegate?.didSelectVideoAtIndex(video, index: indexPath.row)
            self.delegate?.didSelectVideoAtIndex(video, index: indexPath.row, tvosChannelPlaylistVideoDetailsTableViewCell: self)
        } else if let videoChannel = self.channel as? SPLTVideoChannel {
            if let video = videoChannel.video {
                self.delegate?.didSelectVideoAtIndex(video, index: indexPath.row, tvosChannelPlaylistVideoDetailsTableViewCell: self)
            }
        }
    }
}
