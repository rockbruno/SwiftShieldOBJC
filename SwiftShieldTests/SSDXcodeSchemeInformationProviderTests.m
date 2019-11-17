#import <XCTest/XCTest.h>
#import "SSDXcodeOutputParser.h"
#import "SSDDummyLogger.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDSchemeInfoProvider.h"

@interface SSDSchemeInfoProviderTests: XCTestCase
@end

@implementation SSDSchemeInfoProviderTests

- (SSDSchemeInfoProvider*)infoDouble {
    SSDDummyLogger* logger = [SSDDummyLogger new];
    SSDXcodeOutputParser* parser = [[SSDXcodeOutputParser alloc] initWithLogger:logger];
    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@"./text.xcworkspace"];
    return  [[SSDSchemeInfoProvider alloc] initWithProjectFile:dummyFile
                                                                schemeName:@"MyScheme"
                                                         buildOutputParser:parser
                                                                    logger:logger];
}

- (void)test_buildTask_parameters {
    SSDSchemeInfoProvider* info = [self infoDouble];
    NSTask* buildTask = [info buildTask];

    NSArray* expectedArgs = @[@"clean",
                              @"build",
                              @"-workspace",
                              @"./text.xcworkspace",
                              @"-scheme",
                              @"MyScheme"];

    XCTAssertEqualObjects(buildTask.launchPath, @"/usr/bin/xcodebuild");
    XCTAssertEqualObjects(buildTask.arguments, expectedArgs);
}

- (void)test_onNilOutput_errorIsThrown {
    SSDSchemeInfoProvider* info = [self infoDouble];

    NSError* error;
    NSString* nullStr;
    NSArray<SSDModule*>* modules = [info parseModulesFromOutput:nullStr terminationStatus:0 error:&error];

    XCTAssertNotNil(error);
    XCTAssertEqualObjects(modules, @[]);
}

- (void)test_onNonZeroStatusCode_errorIsThrown {
    SSDSchemeInfoProvider* info = [self infoDouble];

    NSError* error;
    NSString* output = @"Output";
    NSArray<SSDModule*>* modules = [info parseModulesFromOutput:output terminationStatus:10 error:&error];

    XCTAssertNotNil(error);
    XCTAssertEqualObjects(modules, @[]);
}

- (void)test_onValidStatusCodeAndOutput_noErrorIsThrown {
    SSDSchemeInfoProvider* info = [self infoDouble];

    NSError* error;
    NSString* output = @"Output";
    [info parseModulesFromOutput:output terminationStatus:0 error:&error];

    XCTAssertNil(error);
}

@end
