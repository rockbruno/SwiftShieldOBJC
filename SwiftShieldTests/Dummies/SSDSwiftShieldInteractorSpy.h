#import <Foundation/Foundation.h>
#import "SSDSwiftShieldInteractor.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDSwiftShieldInteractorSpy : NSObject <SSDSwiftShieldInteractorProtocol>
@property (nonatomic) BOOL getModulesFromProjectCalled;
@property (nonatomic) BOOL obfuscatedModulesCalled;
@end

NS_ASSUME_NONNULL_END
