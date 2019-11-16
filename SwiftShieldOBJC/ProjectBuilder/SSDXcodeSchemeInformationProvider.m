#import <Foundation/Foundation.h>
#import "SSDXcodeSchemeInformationProvider.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDRegex.h"
#import "SSDXcodeOutputParser.h"

@interface SSDXcodeSchemeInformationProvider ()
@property (nonatomic) SSDFile* projectFile;
@property (nonatomic) NSString* schemeName;
@property (nonatomic) SSDXcodeOutputParser* outputParser;
@property (nonatomic) SSDLoggerProtocol logger;
@end

@implementation SSDXcodeSchemeInformationProvider

- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                  buildOutputParser:(SSDXcodeOutputParser*)outputParser
                             logger:(SSDLoggerProtocol)logger {
    self = [super init];
    if (self) {
        _projectFile = projectFile;
        _schemeName = schemeName;
        _outputParser = outputParser;
        _logger = logger;
    }
    return self;
}

- (NSArray<SSDModule*>*)getModulesFromProject:(NSError * _Nullable *)error {
    [self.logger log:@"Building project to retrieve compiler arguments."];

    NSTask* xcodebuildTask = [self buildTask];
    NSPipe* outpipe = [NSPipe new];
    xcodebuildTask.standardOutput = outpipe;
    xcodebuildTask.standardError = outpipe;

    [xcodebuildTask launch];

    NSData* outdata = [[outpipe fileHandleForReading] readDataToEndOfFile];
    NSString* output = [[NSString alloc] initWithData:outdata encoding:NSUTF8StringEncoding];

    return [self parseModulesFromOutput:output
                      terminationStatus:xcodebuildTask.terminationStatus
                                  error:error];
}

- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output
                             terminationStatus:(NSInteger)statusCode
                                         error:(NSError * _Nullable *)error {
    if (!output) {
        *error = [self.logger fatalErrorFor:@"Failed to retrieve output from Xcode."];
        return @[];
    }

    if (statusCode != 0) {
        [self.logger log:[NSString stringWithFormat:@"%@", output]];
        *error = [self.logger fatalErrorFor:@"It looks like xcodebuild failed. The log was printed above."];
        return @[];
    }

    return [self.outputParser parseModulesFromOutput:output];
}

- (NSTask*)buildTask {
    NSString* xcodebuildPath = @"/usr/bin/xcodebuild";
    NSArray* arguments = @[@"clean",
                           @"build",
                           @"-workspace",
                           self.projectFile.path,
                           @"-scheme",
                           self.schemeName];
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = xcodebuildPath;
    task.arguments = arguments;
    return task;
}

@end
