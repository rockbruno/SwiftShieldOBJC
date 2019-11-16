#import <XCTest/XCTest.h>
#import "SSDSwiftShieldController.h"
#import "SSDDummyLogger.h"
#import "SSDSwiftShieldInteractorSpy.h"
#import "SSDMockFile.h"

@interface SSDSwiftShieldControllerTests: XCTestCase
@end

@implementation SSDSwiftShieldControllerTests

- (void)test_running_triggersBuild {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    [controller run];

    XCTAssertTrue(interactorSpy.getModulesFromProjectCalled);
    XCTAssertFalse(controller.didFailToRun);
}

- (void)test_retrievingModules_triggersObfuscation {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    [controller interactor:interactorSpy retrievedModules:@[]];

    XCTAssertTrue(interactorSpy.obfuscatedModulesCalled);
    XCTAssertFalse(controller.didFailToRun);
}

- (void)test_failingToRetrieveModules_failsObfuscation {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    NSError* error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@""}];
    [controller interactor:interactorSpy failedToRetrieveModulesWithError:error];

    XCTAssertTrue(controller.didFailToRun);
}

- (void)test_failingToObfuscateAFile_failsObfuscation {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    NSError* error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@""}];
    [controller interactor:interactorSpy failedToObfuscateWithError:error];

    XCTAssertTrue(controller.didFailToRun);
}

- (void)test_successfulObfuscation_failsIfWritingFileFails {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    SSDMockFile* mockFile = [[SSDMockFile alloc] initWithPath:@""];
    mockFile.shouldFailToWrite = YES;

    BOOL shouldContinue = [controller interactor:interactorSpy didObfuscate:mockFile newContents:@"content"];

    XCTAssertTrue(controller.didFailToRun);
    XCTAssertFalse(shouldContinue);
}

- (void)test_successfulObfuscation_continuesIfWritingSucceeds {
    SSDSwiftShieldInteractorSpy* interactorSpy = [SSDSwiftShieldInteractorSpy new];
    SSDSwiftShieldController* controller = [[SSDSwiftShieldController alloc] initWithInterator:interactorSpy
                                                                                        logger:[SSDDummyLogger new]];

    SSDMockFile* mockFile = [[SSDMockFile alloc] initWithPath:@""];
    mockFile.shouldFailToWrite = NO;

    BOOL shouldContinue = [controller interactor:interactorSpy didObfuscate:mockFile newContents:@"content"];

    XCTAssertFalse(controller.didFailToRun);
    XCTAssertTrue(shouldContinue);
    XCTAssertEqualObjects(mockFile.writtenContents, @"content");
}

@end
