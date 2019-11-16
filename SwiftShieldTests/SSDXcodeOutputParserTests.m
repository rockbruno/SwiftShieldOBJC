#import <XCTest/XCTest.h>
#import "SSDXcodeOutputParser.h"
#import "SSDDummyLogger.h"
#import "SSDModule.h"
#import "SSDFile.h"

@interface SSDXcodeOutputParserTests: XCTestCase
@end

@implementation SSDXcodeOutputParserTests

- (void)test_parsingModulesFromOutput {
    SSDXcodeOutputParser* parser = [[SSDXcodeOutputParser alloc] initWithLogger:[SSDDummyLogger new]];
    NSString* mockXcodeOutput = @"/usr/bin/swiftc foo bar -module-name ModuleFoo compilerArg\n"
                                "fooRandomUselessOutput fooRandomUselessOutput\n"
                                "fooRandomUselessOutput fooRandomUselessOutput\n"
                                "/usr/bin/swiftc bla -module-name ModuleBar test\n"
                                "/usr/bin/swiftc foo bar noModuleHereUselessOutput\n"
                                "fooRandomUselessOutput fooRandomUselessOutput";

    NSArray<SSDModule*>* modules = [parser parseModulesFromOutput:mockXcodeOutput];

    NSArray* expectedModuleFooArgs = @[@"foo", @"bar", @"-module-name", @"ModuleFoo", @"compilerArg", @"-D", @"DEBUG"];
    SSDModule* expectedModuleFoo = [[SSDModule alloc] initWithName:@"ModuleFoo"
                                                       sourceFiles:@[]
                                                 compilerArguments:expectedModuleFooArgs];

    NSArray* expectedModuleBarArgs = @[@"bla", @"-module-name", @"ModuleBar", @"test", @"-D", @"DEBUG"];
    SSDModule* expectedModuleBar = [[SSDModule alloc] initWithName:@"ModuleBar"
                                                       sourceFiles:@[]
                                                 compilerArguments:expectedModuleBarArgs];

    NSArray* expectedModules = @[expectedModuleFoo, expectedModuleBar];

    XCTAssertEqualObjects(modules, expectedModules);
}

- (void)test_parsingSourceFilesFromOutput {
    SSDXcodeOutputParser* parser = [[SSDXcodeOutputParser alloc] initWithLogger:[SSDDummyLogger new]];
    NSString* mockXcodeOutput = @"/usr/bin/swiftc -module-name ModuleFoo compilerArg "
                                "-c /a.swift /b.swift /c.swift -over otherArg";

    NSArray<SSDModule*>* modules = [parser parseModulesFromOutput:mockXcodeOutput];

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

    XCTAssertEqualObjects(modules, @[expectedModule]);
}

- (void)test_parserTreatsForbiddenArguments {
    SSDXcodeOutputParser* parser = [[SSDXcodeOutputParser alloc] initWithLogger:[SSDDummyLogger new]];
    NSString* mockXcodeOutput = @"/usr/bin/swiftc -module-name ModuleFoo a -output-file-map ignored -O -DNDEBUG=1 -parseable-output b -d -incremental -serialize-diagnostics -z -emit-dependencies k";

    NSArray<SSDModule*>* modules = [parser parseModulesFromOutput:mockXcodeOutput];

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

    XCTAssertEqualObjects(modules, @[expectedModule]);
}

@end
