#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSwiftShieldInteractor;

/// A controller that coordinates obfuscation processes.
@interface SSDSwiftShieldController : NSObject

/// Indicates if the obfuscation process failed.
@property (nonatomic) BOOL didFailToRun;

- (instancetype)initWithInterator:(SSDSwiftShieldInteractor*)interactor
                           logger:(SSDLoggerProtocol)logger;

/// Starts the obfuscation process.
- (void)run;
@end

NS_ASSUME_NONNULL_END
