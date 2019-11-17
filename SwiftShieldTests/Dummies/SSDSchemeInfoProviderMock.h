#import <Foundation/Foundation.h>
#import "SSDSchemeInfoProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDSchemeInfoProviderMock: NSObject <SSDSchemeInfoProviderProtocol>
@property (nonatomic) BOOL shouldFail;
@end

NS_ASSUME_NONNULL_END
