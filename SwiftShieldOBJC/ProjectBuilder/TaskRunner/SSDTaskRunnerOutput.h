#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSDTaskRunnerOutput : NSObject
@property (readonly, nonatomic) NSString* output;
@property (readonly, nonatomic) int terminationStatus;

- (instancetype)initWithOutput:(NSString*)output
             terminationStatus:(int)terminationStatus;
@end

NS_ASSUME_NONNULL_END
