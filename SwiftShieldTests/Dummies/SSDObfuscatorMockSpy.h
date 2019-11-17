#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDObfuscatorMockSpy: NSObject <SSDObfuscatorProtocol>
@property (nonatomic) NSInteger registerModuleCallCount;
@property (nonatomic) NSInteger registerModuleCallCountWhenCallingObfuscate;
@end

NS_ASSUME_NONNULL_END
