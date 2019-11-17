#import <Foundation/Foundation.h>
#import "SSDSchemeInfoProvider.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDRegex.h"
#import "SSDTaskRunnerProtocol.h"
#import "SSDTaskRunnerOutput.h"

@interface SSDSchemeInfoProvider ()
@property (nonatomic) SSDFile* projectFile;
@property (nonatomic) NSString* schemeName;
@property (nonatomic) id<SSDTaskRunnerProtocol> taskRunner;
@property (nonatomic) id<SSDLoggerProtocol> logger;
@end

@implementation SSDSchemeInfoProvider

- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                         taskRunner:(id<SSDTaskRunnerProtocol>)taskRunner
                             logger:(id<SSDLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        _projectFile = projectFile;
        _schemeName = schemeName;
        _taskRunner = taskRunner;
        _logger = logger;
    }
    return self;
}

- (NSArray<SSDModule*>*)getModulesFromProject:(NSError * _Nullable *)error {
    [self.logger log:@"Building project to retrieve compiler arguments."];

    NSString* command = @"/usr/bin/xcodebuild";
    NSArray* arguments = @[@"clean",
                           @"build",
                           @"-workspace",
                           self.projectFile.path,
                           @"-scheme",
                           self.schemeName];

    SSDTaskRunnerOutput* result = [self.taskRunner runTaskWithCommand:command
                                                            arguments:arguments];

    if (!result.output) {
        *error = [self.logger fatalErrorFor:@"Failed to retrieve output from Xcode."];
        return @[];
    }

    if (result.terminationStatus != 0) {
        [self.logger log:[NSString stringWithFormat:@"%@", result.output]];
        *error = [self.logger fatalErrorFor:@"It looks like xcodebuild failed. The log was printed above."];
        return @[];
    }

    return [self parseModulesFromOutput: result.output];
}

@end

@implementation SSDSchemeInfoProvider (OutputParsing)

- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output {
    NSMutableArray<SSDModule*>* modules = [NSMutableArray new];
    NSMutableSet<NSString*>* foundModules = [[NSMutableSet alloc] initWithArray:@[]];
    NSArray* lines = [output componentsSeparatedByString:@"\n"];
    [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* moduleName = [SSDRegex firstMatchForRegex:@"(?<=-module-name ).*?(?= )" inText:obj];
        if (moduleName && [foundModules containsObject:moduleName] == NO) {
            [foundModules addObject:moduleName];
            SSDModule* extractedModule = [self parseMergeSwiftModulePhaseLine:obj
                                                                    moduleName:moduleName];
            [modules addObject:extractedModule];
            [self.logger log:[NSString stringWithFormat:@"Found module: %@", moduleName]];
        }
    }];
    return modules;
}

- (SSDModule*)parseMergeSwiftModulePhaseLine:(NSString*)line
                                  moduleName:(NSString*)moduleName {
    NSString* pattern = [NSString stringWithFormat:@"/usr/bin/swiftc.*-module-name %@ .*", moduleName];
    NSString* fullRelevantArguments = [SSDRegex firstMatchForRegex:pattern inText:line];
    NSArray<NSString*>* relevantArguments = [self argumentsSeparatedBySpace:fullRelevantArguments];

    NSArray<SSDFile*>* sourceFiles = [self parseModuleSourceFilesFromArguments:relevantArguments];
    NSArray<NSString*>* compilerArguments = [self parseCompilerArgumentsFromArguments:relevantArguments];

    return [[SSDModule alloc] initWithName:moduleName
                               sourceFiles:sourceFiles
                         compilerArguments:compilerArguments];
}

- (NSArray<NSString*>*)argumentsSeparatedBySpace:(NSString*)arguments {
    NSString* escapedSpacesPlaceholder = @"--SSDEscapedSpace--";
    NSString* withoutEscapedSpaces = [arguments stringByReplacingOccurrencesOfString:@"\\ " withString: escapedSpacesPlaceholder];
    NSMutableArray<NSString*>* argsArray = [[withoutEscapedSpaces componentsSeparatedByString:@" "] mutableCopy];
    [argsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        argsArray[idx] = [obj stringByReplacingOccurrencesOfString:withoutEscapedSpaces withString:@"\\ "];
    }];
    return argsArray;
}

- (NSArray<SSDFile*>*)parseModuleSourceFilesFromArguments:(NSArray<NSString*>*)arguments {
    NSMutableArray<SSDFile*>* files = [NSMutableArray new];
    BOOL __block isInFileZone = NO;
    [arguments enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isInFileZone) {
            if ([obj hasPrefix:@"/"]) {
                SSDFile* file = [[SSDFile alloc] initWithPath:obj];
                [files addObject:file];
            }
            isInFileZone = [obj hasPrefix:@"-"] == NO || files.count == 0;
        } else {
            isInFileZone = [obj isEqualToString:@"-c"];
        }
    }];
    return files;
}

- (NSArray<NSString*>*)parseCompilerArgumentsFromArguments:(NSArray<NSString*>*)arguments {
    NSMutableArray<NSString*>* compilerArgs = [NSMutableArray new];
    NSSet* forbiddenArgs = [[NSSet alloc] initWithArray: @[@"-parseable-output",
                                                           @"-incremental",
                                                           @"-serialize-diagnostics",
                                                           @"-emit-dependencies"]];
    int i = 1;
    while (i < [arguments count]) {
        NSString* arg = arguments[i];
        if ([arg isEqualToString:@"-output-file-map"]) {
            i += 1;
        } else {
            if ([arg isEqualToString:@"-O"]) {
                [compilerArgs addObject:@"-Onone"];
            } else if ([arg isEqualToString:@"-DNDEBUG=1"]) {
                [compilerArgs addObject:@"-DDEBUG=1"];
            } else if (![forbiddenArgs containsObject:arg]) {
                [compilerArgs addObject:arg];
            }
        }
        i += 1;
    }

    [compilerArgs addObject:@"-D"];
    [compilerArgs addObject:@"DEBUG"];

    return compilerArgs;
}

@end
