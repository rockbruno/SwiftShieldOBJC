#import "SSDObfuscatorDelegateSpy.h"

@implementation SSDObfuscatorDelegateSpy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _receivedNewContent = @"";
    }
    return self;
}

- (void)obfuscator:(nonnull id<SSDObfuscatorProtocol>)obfuscator didFailToObfuscateFile:(nonnull SSDFile *)file withError:(nonnull NSError *)error {

}

- (BOOL)obfuscator:(nonnull id<SSDObfuscatorProtocol>)obfuscator didObfuscateFile:(nonnull SSDFile *)file newContent:(nonnull NSString *)newContent {
    self.receivedNewContent = newContent;
    return YES;
}

@end
