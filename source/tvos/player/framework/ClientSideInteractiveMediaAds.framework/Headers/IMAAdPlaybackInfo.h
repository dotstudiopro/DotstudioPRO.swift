#import <Foundation/Foundation.h>

/**
 *  Groups various properties of the ad player.
 */
@protocol IMAAdPlaybackInfo<NSObject>

/**
 *  The current media time of the ad, or 0 if no ad loaded.
 */
@property(nonatomic, readonly) NSTimeInterval currentMediaTime;

/**
 *  The total media time of the ad, or 0 if no ad loaded.
 */
@property(nonatomic, readonly) NSTimeInterval totalMediaTime;

/**
 *  The buffered media time of the ad, or 0 if no ad loaded.
 */
@property(nonatomic, readonly) NSTimeInterval bufferedMediaTime;

/**
 *  Whether or not the ad is currently playing.
 */
@property(nonatomic, readonly, getter=isPlaying) BOOL playing;

@end
