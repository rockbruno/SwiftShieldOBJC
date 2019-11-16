#import "SSDXcodeOutputParser.h"
#import "SSDModule.h"
#import "SSDRegex.h"
#import "SSDLoggerProtocol.h"
#import "SSDFile.h"

@interface SSDXcodeOutputParser ()
@property (nonatomic) id<SSDLoggerProtocol> logger;
@end

@implementation SSDXcodeOutputParser

- (instancetype)initWithLogger:(id<SSDLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        _logger = logger;
    }
    return self;
}

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
