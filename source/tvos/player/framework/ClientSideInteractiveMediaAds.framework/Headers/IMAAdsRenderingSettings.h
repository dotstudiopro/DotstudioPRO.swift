#import <UIKit/UIKit.h>

/**
 *  The default value of |bitrate property|, causes the effective bitrate to
 *  be automatically selected.
 */
extern const int kIMAAutodetectBitrate;

#pragma mark - IMAAdsRenderingSettings

/**
 *  Set of properties that influence how ads are rendered.
 */
@interface IMAAdsRenderingSettings : NSObject

/**
 *  If specified, the SDK will play the media with MIME type on the list.
 *  List of strings specifying the MIME types. When nil or empty, the SDK will
 *  use it's default list of MIME types supported on iOS.
 *  Example: @[ @"video/mp4", @"application/x-mpegURL" ]
 *  The property is an empty array by default.
 */
@property(nonatomic, copy) NSArray<NSString *> *mimeTypes;

/**
 *  Maximum recommended bitrate. The value is in kbit/s.
 *  SDK will pick media with bitrate below the specified max, or the closest
 *  bitrate if there is no media with smaller bitrate found.
 *  Default value, |kIMAAutodetectBitrate|, means the bitrate will be selected
 *  by the SDK, using the currently detected network speed (cellular or Wi-Fi).
 */
@property(nonatomic) int bitrate;

/**
 *  For VMAP and ad rules playlists, only play ad breaks scheduled after this time (in seconds).
 *  This setting is strictly after the specified time. For example, setting playAdsAfterTime to
 *  15 will ignore an ad break scheduled to play at 15s.
 */
@property(nonatomic) NSTimeInterval playAdsAfterTime;

@end
