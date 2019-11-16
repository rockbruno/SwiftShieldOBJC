#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"
#import "SSDSwiftShieldInteractor.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSwiftShieldInteractor;
@protocol SSDSwiftShieldInteractorProtocol;

/// A controller that coordinates obfuscation processes.
@interface SSDSwiftShieldController : NSObject

/// Indicates if the obfuscation process failed.
@property (nonatomic) BOOL didFailToRun;

- (instancetype)initWithInterator:(id<SSDSwiftShieldInteractorProtocol>)interactor
                           logger:(id<SSDLoggerProtocol>)logger;

/// Starts the obfuscation process.
- (void)run;
@end

@interface SSDSwiftShieldController (InteractorDelegate) <SSDSwiftShieldInteractorDelegate>
@end

NS_ASSUME_NONNULL_END
