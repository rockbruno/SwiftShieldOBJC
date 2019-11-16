#import <Foundation/Foundation.h>
#import "SSDLogger.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSwiftShieldInteractor;

@interface SSDSwiftShieldController : NSObject

@property (nonatomic) BOOL didFailToRun;

- (instancetype)initWithInterator:(SSDSwiftShieldInteractor*)interactor
                           logger:(SSDLogger)logger;

- (void)run;
@end

NS_ASSUME_NONNULL_END
