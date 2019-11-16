#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSwiftShieldInteractor;

@interface SSDSwiftShieldController : NSObject

@property (nonatomic) BOOL didFailToRun;

- (instancetype)initWithInterator:(SSDSwiftShieldInteractor*)interactor
                           logger:(SSDLoggerProtocol)logger;

- (void)run;
@end

NS_ASSUME_NONNULL_END
