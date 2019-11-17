#import <Foundation/Foundation.h>
#import "SSDTaskRunnerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDTaskRunnerMockSpy: NSObject <SSDTaskRunnerProtocol>
@property (nonatomic) BOOL shouldFail;
@property (nullable, nonatomic) NSString* mockOutput;
@property (nonatomic) NSString* receivedCommand;
@property (nonatomic) NSArray* receivedArguments;
@end

NS_ASSUME_NONNULL_END
