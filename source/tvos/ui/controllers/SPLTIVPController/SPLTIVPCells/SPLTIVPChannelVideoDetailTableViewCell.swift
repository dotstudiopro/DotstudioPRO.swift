//
//  SPLTIVPChannelVideoDetailTableViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

public protocol SPLTIVPChannelVideoDetailTableViewCellDelegate {
    func didClickPlayButton(_ sender: AnyObject)
}

open class SPLTIVPChannelVideoDetailTableViewCell: UITableViewCell {

    open var channel: SPLTChannel? {
        didSet {
            self.updateUI()
        }
    }
    open var video: SPLTVideo? {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var viewGradient: EZYGradientView?
    @IBOutlet open weak var viewChannelVIdeoInfo: UIView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var labelDescription: UILabel?
    @IBOutlet open weak  var textViewDescription: UITextView?
    @IBOutlet open weak var labelInfo: UILabel?
    @IBOutlet open weak var buttonPlay: UIButton?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.labelTitle?.text = ""
        self.labelInfo?.text = ""
        self.labelDescription?.text = ""
        self.textViewDescription?.text = ""
    }
    
    func updateUI() {
        
        if let video = self.video {
            self.labelTitle?.text = video.strTitle
            self.labelInfo?.text = video.strVideoInfo
            self.labelDescription?.text = video.strDescription
            self.textViewDescription?.text = video.strDescription
            if let strImagePath = video.thumb {
                do {
                    let imageFrame = self.imageViewChannelVideo?.frame
                    let url = try SPLTFullPathRouter.imagePath(strImagePath, Int((imageFrame?.width)!), Int((imageFrame?.height)!)).asURL()
                    self.imageViewChannelVideo?.splt_setImageFromURL(url)
                } catch {
                    print("error while seting hnk image")
                }
            }
        } else if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel, spltMultiLevelChannel.iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
            let curChildChannel = spltMultiLevelChannel.childChannels[spltMultiLevelChannel.iCurChildChannelIndex]
            self.labelTitle?.text = curChildChannel.strTitle
            self.labelInfo?.text = curChildChannel.strChannelInfo
            self.labelDescription?.text = curChildChannel.strDescription
            self.textViewDescription?.text = curChildChannel.strDescription
            
            if let strImagePath = curChildChannel.poster {
                do {
                    let imageFrame = self.imageViewChannelVideo?.frame
                    let url = try SPLTFullPathRouter.imagePath(strImagePath, Int((imageFrame?.width)!), Int((imageFrame?.height)!)).asURL()
                    self.imageViewChannelVideo?.splt_setImageFromURL(url)
                } catch {
                    print("error while seting hnk image")
                }
            }
        } else if let channel = self.channel {
            self.labelTitle?.text = channel.strTitle
            self.labelInfo?.text = channel.strChannelInfo
            self.labelDescription?.text = channel.strDescription
            self.textViewDescription?.text = channel.strDescription
            
            if let strImagePath = channel.poster {
                do {
                    let imageFrame = self.imageViewChannelVideo?.frame
                    let url = try SPLTFullPathRouter.imagePath(strImagePath, Int((imageFrame?.width)!), Int((imageFrame?.height)!)).asURL()
                    self.imageViewChannelVideo?.splt_setImageFromURL(url)
                } catch {
                    print("error while seting hnk image")
                }
            }
        }
    }
    
    //    //MARK:- IBAction methods
    //    @IBAction func didClickPlayButton(_ sender: AnyObject) {
    //        self.delegate?.didClickPlayButton(sender)
    //    }
    
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if self.isFocused {
            //self.buttonPlay.makeFocused()
        } else {
            //self.buttonPlay.makeUnFocused()
        }
    }
}
