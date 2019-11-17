#import <XCTest/XCTest.h>
#import "SSDSwiftShieldInteractor.h"
#import "SSDSchemeInfoProviderMock.h"
#import "SSDObfuscatorMockSpy.h"
#import "SSDDummyLogger.h"
#import "SSDSwiftShieldInteractorDelegateSpy.h"
#import "SSDModule.h"
#import "SSDFile.h"

@interface SSDSwiftShieldInteractorTests: XCTestCase
@end

@implementation SSDSwiftShieldInteractorTests

- (void)test_gettingModules_callsDelegateOnSuccess {
    SSDSchemeInfoProviderMock* providerMock = [SSDSchemeInfoProviderMock new];
    SSDObfuscatorMockSpy* obfuscatorMock = [SSDObfuscatorMockSpy new];
    SSDSwiftShieldInteractor* itr = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:providerMock
                                                                                          logger:[SSDDummyLogger new]
                                                                                      obfuscator:obfuscatorMock];

    SSDSwiftShieldInteractorDelegateSpy* delegateSpy = [SSDSwiftShieldInteractorDelegateSpy new];
    itr.delegate = delegateSpy;

    [itr getModulesFromProject];

    XCTAssertTrue(delegateSpy.buildModulesSuccessCalled);
    XCTAssertFalse(delegateSpy.buildModulesFailureCalled);
}

- (void)test_gettingModules_callsDelegateOnFailure {
    SSDSchemeInfoProviderMock* providerMock = [SSDSchemeInfoProviderMock new];
    SSDObfuscatorMockSpy* obfuscatorMock = [SSDObfuscatorMockSpy new];
    SSDSwiftShieldInteractor* itr = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:providerMock
                                                                                          logger:[SSDDummyLogger new]
                                                                                      obfuscator:obfuscatorMock];

    SSDSwiftShieldInteractorDelegateSpy* delegateSpy = [SSDSwiftShieldInteractorDelegateSpy new];
    itr.delegate = delegateSpy;


    providerMock.shouldFail = YES;

    [itr getModulesFromProject];

    XCTAssertFalse(delegateSpy.buildModulesSuccessCalled);
    XCTAssertTrue(delegateSpy.buildModulesFailureCalled);
}

- (void)test_obfuscating_registerAllModulesBeforeObfuscating {
    SSDSchemeInfoProviderMock* providerMock = [SSDSchemeInfoProviderMock new];
    SSDObfuscatorMockSpy* obfuscatorMock = [SSDObfuscatorMockSpy new];
    SSDSwiftShieldInteractor* itr = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:providerMock
                                                                                          logger:[SSDDummyLogger new]
                                                                                      obfuscator:obfuscatorMock];

    SSDSwiftShieldInteractorDelegateSpy* delegateSpy = [SSDSwiftShieldInteractorDelegateSpy new];
    itr.delegate = delegateSpy;

    SSDModule* module = [[SSDModule alloc] initWithName:@"" sourceFiles:@[] compilerArguments:@[]];
    [itr obfuscateModules:@[module, module, module]];

    XCTAssertEqual(obfuscatorMock.registerModuleCallCount, 3);
    XCTAssertEqual(obfuscatorMock.registerModuleCallCountWhenCallingObfuscate, 3);
}

- (void)test_obfuscationSuccessDelegate_isRoutedToInteractorDelegate {
    SSDSchemeInfoProviderMock* providerMock = [SSDSchemeInfoProviderMock new];
    SSDObfuscatorMockSpy* obfuscatorMock = [SSDObfuscatorMockSpy new];
    SSDSwiftShieldInteractor* itr = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:providerMock
                                                                                          logger:[SSDDummyLogger new]
                                                                                      obfuscator:obfuscatorMock];

    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@""];

    SSDSwiftShieldInteractorDelegateSpy* delegateSpy = [SSDSwiftShieldInteractorDelegateSpy new];
    itr.delegate = delegateSpy;

    [itr obfuscator:obfuscatorMock didObfuscateFile:dummyFile newContent:@"dummyContent"];

    XCTAssertEqualObjects(delegateSpy.receivedObfuscatedContent, @"dummyContent");
    XCTAssertFalse(delegateSpy.failedToObfuscateCalled);
}

- (void)test_obfuscationFailureDelegate_isRoutedToInteractorDelegate {
    SSDSchemeInfoProviderMock* providerMock = [SSDSchemeInfoProviderMock new];
    SSDObfuscatorMockSpy* obfuscatorMock = [SSDObfuscatorMockSpy new];
    SSDSwiftShieldInteractor* itr = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:providerMock
                                                                                          logger:[SSDDummyLogger new]
                                                                                      obfuscator:obfuscatorMock];

    SSDFile* dummyFile = [[SSDFile alloc] initWithPath:@""];

    SSDSwiftShieldInteractorDelegateSpy* delegateSpy = [SSDSwiftShieldInteractorDelegateSpy new];
    itr.delegate = delegateSpy;

    NSError* error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@""}];
    [itr obfuscator:obfuscatorMock didFailToObfuscateFile:dummyFile withError:error];

    XCTAssertTrue(delegateSpy.failedToObfuscateCalled);
    XCTAssertEqualObjects(delegateSpy.receivedObfuscatedContent, nil);
}

@end
