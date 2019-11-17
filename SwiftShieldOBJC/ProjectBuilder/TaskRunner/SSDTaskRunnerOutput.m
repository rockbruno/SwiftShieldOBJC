#import "SSDTaskRunnerOutput.h"

@implementation SSDTaskRunnerOutput
- (instancetype)initWithOutput:(NSString*)output
             terminationStatus:(int)terminationStatus
{
    self = [super init];
    if (self) {
        _output = output;
        _terminationStatus = terminationStatus;
    }
    return self;
}
@end
