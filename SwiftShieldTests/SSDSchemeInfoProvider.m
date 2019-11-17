#import <XCTest/XCTest.h>
#import "SSDDummyLogger.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDSchemeInfoProvider.h"
#import "SSDTaskRunnerMockSpy.h"

@interface SSDSchemeInfoProviderTests: XCTestCase
@end

@implementation SSDSchemeInfoProviderTests

- (void)test_gettingModules_runsXcodebuildTask {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    [provider getModulesFromProject:nil];

    NSArray* expectedArgs = @[@"clean",
                              @"build",
                              @"-workspace",
                              @"./text.xcworkspace",
                              @"-scheme",
                              @"MyScheme"];

    XCTAssertEqualObjects(runnerSpy.receivedCommand, @"/usr/bin/xcodebuild");
    XCTAssertEqualObjects(runnerSpy.receivedArguments, expectedArgs);
}

- (void)test_onNilOutput_errorIsThrown {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    runnerSpy.mockOutput = nil;

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    XCTAssertNotNil(error);
    XCTAssertEqualObjects(modules, @[]);
}


- (void)test_onNonZeroStatusCode_errorIsThrown {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    runnerSpy.shouldFail = YES;
    runnerSpy.mockOutput = @"Output";

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    XCTAssertNotNil(error);
    XCTAssertEqualObjects(modules, @[]);
}

- (void)test_onInvalidOutput_nothingIsReturned {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    runnerSpy.mockOutput = @"Output";

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(modules, @[]);
}

- (void)test_onValidOutput_modulesAreReturned {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    NSString* mockXcodeOutput = @"/usr/bin/swiftc foo bar -module-name ModuleFoo compilerArg\n"
                                "fooRandomUselessOutput fooRandomUselessOutput\n"
                                "fooRandomUselessOutput fooRandomUselessOutput\n"
                                "/usr/bin/swiftc bla -module-name ModuleBar test\n"
                                "/usr/bin/swiftc foo bar noModuleHereUselessOutput\n"
                                "fooRandomUselessOutput fooRandomUselessOutput";

    runnerSpy.mockOutput = mockXcodeOutput;

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    NSArray* expectedModuleFooArgs = @[@"foo", @"bar", @"-module-name", @"ModuleFoo", @"compilerArg", @"-D", @"DEBUG"];
    SSDModule* expectedModuleFoo = [[SSDModule alloc] initWithName:@"ModuleFoo"
                                                       sourceFiles:@[]
                                                 compilerArguments:expectedModuleFooArgs];

    NSArray* expectedModuleBarArgs = @[@"bla", @"-module-name", @"ModuleBar", @"test", @"-D", @"DEBUG"];
    SSDModule* expectedModuleBar = [[SSDModule alloc] initWithName:@"ModuleBar"
                                                       sourceFiles:@[]
                                                 compilerArguments:expectedModuleBarArgs];

    NSArray* expectedModules = @[expectedModuleFoo, expectedModuleBar];

    XCTAssertNil(error);
    XCTAssertEqualObjects(modules, expectedModules);
}

- (void)test_outputWithSourceFiles_parsesesSourceFiles {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    NSString* mockXcodeOutput = @"/usr/bin/swiftc -module-name ModuleFoo compilerArg "
                                "-c /a.swift /b.swift /c.swift -over otherArg";

    runnerSpy.mockOutput = mockXcodeOutput;

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    NSArray* expectedModuleArgs = @[@"-module-name",
                                    @"ModuleFoo",
                                    @"compilerArg",
                                    @"-c",
                                    @"/a.swift",
                                    @"/b.swift",
                                    @"/c.swift",
                                    @"-over",
                                    @"otherArg",
                                    @"-D",
                                    @"DEBUG"];

    NSArray* expectedSourceFiles = @[[[SSDFile alloc] initWithPath:@"/a.swift"],
                                     [[SSDFile alloc] initWithPath:@"/b.swift"],
                                     [[SSDFile alloc] initWithPath:@"/c.swift"]];

    SSDModule* expectedModule = [[SSDModule alloc] initWithName:@"ModuleFoo"
                                                    sourceFiles:expectedSourceFiles
                                              compilerArguments:expectedModuleArgs];

    XCTAssertNil(error);
    XCTAssertEqualObjects(modules, @[expectedModule]);
}

- (void)test_parserTreatsForbiddenArguments {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    SSDTaskRunnerMockSpy* runnerSpy = [SSDTaskRunnerMockSpy new];
    SSDSchemeInfoProvider* provider =  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                               schemeName:@"MyScheme"
                                                                               taskRunner:runnerSpy
                                                                                   logger:logger];

    NSString* mockXcodeOutput = @"/usr/bin/swiftc -module-name ModuleFoo a -output-file-map ignored -O -DNDEBUG=1 -parseable-output b -d -incremental -serialize-diagnostics -z -emit-dependencies k";

    runnerSpy.mockOutput = mockXcodeOutput;

    NSError* error;
    NSArray<SSDModule*>* modules = [provider getModulesFromProject:&error];

    NSArray* expectedModuleArgs = @[@"-module-name",
                                    @"ModuleFoo",
                                    @"a",
                                    @"-Onone",
                                    @"-DDEBUG=1",
                                    @"b",
                                    @"-d",
                                    @"-z",
                                    @"k",
                                    @"-D",
                                    @"DEBUG"];

    SSDModule* expectedModule = [[SSDModule alloc] initWithName:@"ModuleFoo"
                                                    sourceFiles:@[]
                                              compilerArguments:expectedModuleArgs];

    XCTAssertNil(error);
    XCTAssertEqualObjects(modules, @[expectedModule]);
}

@end
