#import "SSDDummyLogger.h"

@implementation SSDDummyLogger
- (nonnull NSError *)fatalErrorFor:(nonnull NSString *)message {
    return [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{}];
}
- (void)log:(nonnull NSString *)message {}
@end
