#import <Cocoa/Cocoa.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A `SSDLogger` that logs to `NSLog`.
@interface SSDNSLogLogger : NSObject <SSDLogger>
@end

NS_ASSUME_NONNULL_END
