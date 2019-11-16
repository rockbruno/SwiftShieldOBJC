#import "SSDNSLogLogger.h"

@implementation SSDNSLogLogger
- (void)log:(NSString *)message {
    NSLog(@"%@", message);
}

- (NSError*)fatalErrorFor:(NSString *)message {
    return [[NSError alloc] initWithDomain:@"com.rockbruno.swiftshield"
                                      code:0
                                  userInfo:@{NSLocalizedDescriptionKey: message}];
}
@end
