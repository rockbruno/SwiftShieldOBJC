#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSDLoggerProtocol
- (void)log:(NSString*)message;
- (NSError*)fatalErrorFor:(NSString*)message;
@end

typedef id<SSDLoggerProtocol> SSDLogger;

NS_ASSUME_NONNULL_END
