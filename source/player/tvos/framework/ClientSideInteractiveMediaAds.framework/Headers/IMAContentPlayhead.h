#import <Foundation/Foundation.h>

/**
 *  Property name used for key value observation.
 */
extern NSString *const kIMAPropertyCurrentTime;

/**
 *  Defines an interface for a class that tracks video content progress and
 *  exposes a key value observable property |currentTime|.
 *  The SDK provides an implementation for tracking AVPlayer-based playback
 *  in the IMAAVPlayerContentPlayhead.
 *  Publishers can supply their own implementation by implementing this
 *  interface and this way support any other video playback implementation
 *  they might have.
 */
@protocol IMAContentPlayhead

/**
 *  Reflects the current playback time in seconds for the content.
 *  The property is key value observable.
 */
@property(nonatomic, readonly) NSTimeInterval currentTime;

@end
