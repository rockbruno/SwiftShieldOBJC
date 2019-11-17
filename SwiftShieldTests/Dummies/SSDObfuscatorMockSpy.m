#import "SSDObfuscatorMockSpy.h"

@implementation SSDObfuscatorMockSpy

@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _registerModuleCallCount = 0;
        _registerModuleCallCountWhenCallingObfuscate = 0;
    }
    return self;
}

- (void)obfuscate {
    self.registerModuleCallCountWhenCallingObfuscate = self.registerModuleCallCount;
}

- (void)registerModuleForObfuscation:(nonnull SSDModule *)module {
    self.registerModuleCallCount += 1;
}
@end
