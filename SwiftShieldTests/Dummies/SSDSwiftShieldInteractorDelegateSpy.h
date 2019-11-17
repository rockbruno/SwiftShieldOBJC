#import <Foundation/Foundation.h>
#import "SSDSwiftShieldInteractorDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDSwiftShieldInteractorDelegateSpy: NSObject <SSDSwiftShieldInteractorDelegate>
@property (nonatomic) BOOL buildModulesSuccessCalled;
@property (nonatomic) BOOL buildModulesFailureCalled;
@property (nonatomic) NSString* receivedObfuscatedContent;
@property (nonatomic) BOOL failedToObfuscateCalled;
@end

NS_ASSUME_NONNULL_END
