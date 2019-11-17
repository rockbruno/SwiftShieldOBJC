#import <Foundation/Foundation.h>

@class SSDTaskRunnerOutput;

NS_ASSUME_NONNULL_BEGIN

@protocol SSDTaskRunnerProtocol
-(SSDTaskRunnerOutput*)runTaskWithCommand:(NSString*)command
                                arguments:(NSArray*)arguments;
@end

NS_ASSUME_NONNULL_END
