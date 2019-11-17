#import "SSDNSLogLogger.h"

#define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

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
