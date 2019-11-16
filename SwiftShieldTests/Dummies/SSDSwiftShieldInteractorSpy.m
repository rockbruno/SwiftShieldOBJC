#import "SSDSwiftShieldInteractorSpy.h"

@implementation SSDSwiftShieldInteractorSpy

@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _getModulesFromProjectCalled = NO;
        _obfuscatedModulesCalled = NO;
    }
    return self;
}

- (void)getModulesFromProject {
    self.getModulesFromProjectCalled = YES;
}

- (void)obfuscateModules:(nonnull NSArray<SSDModule *> *)modules {
    self.obfuscatedModulesCalled = YES;
}

@end
