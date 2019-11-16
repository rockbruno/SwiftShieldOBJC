#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSDLogger
- (void)log:(NSString*)message;
- (NSError*)fatalErrorFor:(NSString*)message;
@end

typedef id<SSDLogger> SSDLoggerProtocol;

NS_ASSUME_NONNULL_END
