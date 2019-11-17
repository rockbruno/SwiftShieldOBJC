#import "SSDSwiftShieldInteractorDelegateSpy.h"

@implementation SSDSwiftShieldInteractorDelegateSpy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _buildModulesFailureCalled = NO;
        _buildModulesSuccessCalled = NO;
        _receivedObfuscatedContent = nil;
        _failedToObfuscateCalled = NO;
    }
    return self;
}

- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor retrievedModules:(NSArray<SSDModule *> *)modules {
    self.buildModulesSuccessCalled = YES;
}

- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToRetrieveModulesWithError:(NSError *)error {
    self.buildModulesFailureCalled = YES;
}

- (BOOL)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor didObfuscate:(SSDFile *)file newContents:(NSString *)newContents {
    self.receivedObfuscatedContent = newContents;
    return YES;
}

- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToObfuscateWithError:(NSError *)error {
    self.failedToObfuscateCalled = YES;
}

@end
