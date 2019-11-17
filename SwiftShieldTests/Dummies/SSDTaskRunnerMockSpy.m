#import "SSDTaskRunnerMockSpy.h"
#import "SSDTaskRunnerOutput.h"

@implementation SSDTaskRunnerMockSpy
- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldFail = NO;
        _mockOutput = @"";
        _receivedCommand = @"";
        _receivedArguments = @[];
    }
    return self;
}

- (nonnull SSDTaskRunnerOutput *)runTaskWithCommand:(nonnull NSString *)command arguments:(nonnull NSArray *)arguments {
    self.receivedCommand = command;
    self.receivedArguments = arguments;
    if (self.shouldFail) {
        return [[SSDTaskRunnerOutput alloc] initWithOutput:@"" terminationStatus:1];
    } else {
        return [[SSDTaskRunnerOutput alloc] initWithOutput:self.mockOutput terminationStatus:0];
    }
}

@end
