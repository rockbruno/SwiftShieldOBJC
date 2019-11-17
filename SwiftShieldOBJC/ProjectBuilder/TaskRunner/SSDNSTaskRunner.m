#import "SSDNSTaskRunner.h"
#import "SSDTaskRunnerOutput.h"

@implementation SSDNSTaskRunner

- (SSDTaskRunnerOutput*)runTaskWithCommand:(NSString*)command
                                arguments:(NSArray*)arguments {
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = command;
    task.arguments = arguments;

    NSPipe* outpipe = [NSPipe new];
    task.standardOutput = outpipe;
    task.standardError = outpipe;

    [task launch];
    [task waitUntilExit];

    NSData* outdata = [[outpipe fileHandleForReading] readDataToEndOfFile];
    NSString* outputString = [[NSString alloc] initWithData:outdata encoding:NSUTF8StringEncoding];
    SSDTaskRunnerOutput* output = [[SSDTaskRunnerOutput alloc] initWithOutput:outputString
                                                            terminationStatus:task.terminationStatus];
    return output;
}

@end
