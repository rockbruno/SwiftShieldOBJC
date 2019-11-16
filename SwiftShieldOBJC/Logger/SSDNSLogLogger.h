#import <Cocoa/Cocoa.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A `SSDLogger` that logs to `NSLog`.
@interface SSDNSLogLogger : NSObject <SSDLoggerProtocol>
@end

NS_ASSUME_NONNULL_END
