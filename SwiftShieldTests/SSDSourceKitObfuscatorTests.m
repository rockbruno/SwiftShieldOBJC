#import <XCTest/XCTest.h>
#import "SSDSourceKit.h"
#import "SSDSourceKitObfuscator.h"
#import "SSDDummyLogger.h"
#import "SSDSourceKitObfuscatorDataStore.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDIndexedFile.h"
#import "SSDReference.h"
#import "SSDObfuscatorDelegateSpy.h"

@interface SSDSourceKitObfuscatorTests: XCTestCase
@end

@implementation SSDSourceKitObfuscatorTests

- (NSString*)temporaryFilePathForFile:(NSString*)name {
    NSString* directory = NSTemporaryDirectory();
    return [directory stringByAppendingString:name];
}

- (NSArray*)sourceKitCompilerArgumentsForMockModule:(NSString*)sourceFilePath {
    return @[@"-module-name",
             @"MockModule",
             @"-Onone",
             @"-enable-batch-mode",
             @"-enforce-exclusivity=checked",
             @"-DDEBUG",
             @"-D",
             @"COCOAPODS",
             @"-suppress-warnings",
             @"-sdk",
             @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.1.sdk",
             @"-target",
             @"armv7-apple-ios8.0",
             @"-g",
             @"-Xfrontend",
             @"-serialize-debugging-options",
             @"-embed-bitcode-marker",
             @"-enable-testing",
             @"-swift-version",
             @"4",
             @"-c",
             @"-j12",
             sourceFilePath,
             @"-Xcc",
             @"-iquote",
             @"-Xcc",
             @"-ivfsoverlay",
             @"-Xcc",
             @"-iquote",
             @"-Xcc",
             @"-DPOD_CONFIGURATION_DEBUG=1",
             @"-Xcc",
             @"-DDEBUG=1",
             @"-Xcc",
             @"-DCOCOAPODS=1",
             @"-import-underlying-module",
             @"-Xcc",
             @"-ivfsoverlay",
             @"-D",
             @"DEBUG"];
}

- (void)test_moduleRegistration {
    SSDSourceKit* sourceKit = [SSDSourceKit new];
    [sourceKit start];
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];

    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    NSString* mockPath = [self temporaryFilePathForFile:@"moduleRegistration.swift"];
    SSDFile* mockFile = [[SSDFile alloc] initWithPath:mockPath];
    [mockFile writeContents:@"class Foo {}" error:nil];

    NSArray* args = [self sourceKitCompilerArgumentsForMockModule:mockPath];
    SSDModule* mockModule = [[SSDModule alloc] initWithName:@"MockModule"
                                                sourceFiles:@[mockFile]
                                          compilerArguments:args];

    [obfuscator registerModuleForObfuscation:mockModule];

    NSSet* expectedSet = [[NSSet alloc] initWithArray:@[@"s:10MockModule3FooC"]];

    XCTAssertEqualObjects(dataStore.processedUsrs, expectedSet);
    XCTAssertEqualObjects(dataStore.indexedFiles.firstObject.file, mockFile);
}

- (void)test_removeParameterInformationFromString {
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SSDSourceKit new]
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    NSString* methodName = @"fooFunc(parameter:parameter2:)";
    XCTAssertEqualObjects([obfuscator removeParameterInformationFromString:methodName], @"fooFunc");

    NSString* propertyName = @"barProp";
    XCTAssertEqualObjects([obfuscator removeParameterInformationFromString:propertyName], @"barProp");
}

- (void)test_obfuscation_sendsCorrectObfuscatedContentToDelegate {

    SSDSourceKit* sourceKit = [SSDSourceKit new];
    [sourceKit start];
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];

    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    SSDObfuscatorDelegateSpy* delegateSpy = [SSDObfuscatorDelegateSpy new];
    obfuscator.delegate = delegateSpy;

    NSString* mockPath = [self temporaryFilePathForFile:@"moduleRegistration.swift"];
    SSDFile* mockFile = [[SSDFile alloc] initWithPath:mockPath];
    [mockFile writeContents:@"class Foo { func bar() {} }" error:nil];

    NSArray* args = [self sourceKitCompilerArgumentsForMockModule:mockPath];
    SSDModule* mockModule = [[SSDModule alloc] initWithName:@"MockModule"
                                                sourceFiles:@[mockFile]
                                          compilerArguments:args];

    dataStore.obfuscatedNames[@"Foo"] = @"OBSFoo";
    dataStore.obfuscatedNames[@"bar"] = @"OBSBar";

    [obfuscator registerModuleForObfuscation:mockModule];
    [obfuscator obfuscate];

    XCTAssertEqualObjects(delegateSpy.receivedNewContent, @"class OBSFoo { func OBSBar() {} }");
}

- (void)test_obfuscation_ignoresInternalCode {

    SSDSourceKit* sourceKit = [SSDSourceKit new];
    [sourceKit start];
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];

    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    SSDObfuscatorDelegateSpy* delegateSpy = [SSDObfuscatorDelegateSpy new];
    obfuscator.delegate = delegateSpy;

    NSString* mockPath = [self temporaryFilePathForFile:@"moduleRegistration.swift"];
    SSDFile* mockFile = [[SSDFile alloc] initWithPath:mockPath];
    [mockFile writeContents:@"import UIKit; class Foo: UIViewController { func viewDidLoad() {} }" error:nil];

    NSArray* args = [self sourceKitCompilerArgumentsForMockModule:mockPath];
    SSDModule* mockModule = [[SSDModule alloc] initWithName:@"MockModule"
                                                sourceFiles:@[mockFile]
                                          compilerArguments:args];

    dataStore.obfuscatedNames[@"Foo"] = @"OBSFoo";

    [obfuscator registerModuleForObfuscation:mockModule];
    [obfuscator obfuscate];

    XCTAssertEqualObjects(delegateSpy.receivedNewContent, @"import UIKit; class OBSFoo: UIViewController { func viewDidLoad() {} }");
}

- (void)test_obfuscatedString_cachesSimilarStrings {
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SSDSourceKit new]
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    NSString* fooString = @"fooString";
    XCTAssertNil(dataStore.obfuscatedNames[fooString]);

    NSString* obfuscation = [obfuscator obfuscatedStringForString:fooString];

    XCTAssertNotNil(dataStore.obfuscatedNames[fooString]);
    XCTAssertNotEqualObjects(fooString, obfuscation);

    NSString* sameObfuscation = [obfuscator obfuscatedStringForString:fooString];
    XCTAssertEqualObjects(obfuscation, sameObfuscation);

    dataStore.obfuscatedNames[fooString] = nil;
    NSString* differentObfuscation = [obfuscator obfuscatedStringForString:fooString];
    XCTAssertNotEqualObjects(obfuscation, differentObfuscation);
}

- (void)test_fileContentsObfuscationBasedOnReferences {
    NSString* file = @"class Foo {\n"
                     @"    let `default` = 3\n"
                     @"}";

    SSDReference* defaultDecl = [[SSDReference alloc] initWithName:@"default" line:2 column:9];
    SSDReference* fooDecl = [[SSDReference alloc] initWithName:@"Foo" line:1 column:7];

    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SSDSourceKit new]
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    dataStore.obfuscatedNames[@"Foo"] = @"AAAAA";
    dataStore.obfuscatedNames[@"default"] = @"BBBBB";

    NSString* obfuscatedFile = [obfuscator getObfuscatedFile:file withReferences:@[defaultDecl, fooDecl]];

    XCTAssertEqualObjects(obfuscatedFile, @"class AAAAA {\n"
                                          @"    let BBBBB = 3\n"
                                          @"}");
}

- (void)test_fileContentsObfuscation_ignoresDuplicates {
    NSString* file = @"class Foo {\n"
                     @"    let `default` = 3\n"
                     @"}";

    SSDReference* defaultDecl = [[SSDReference alloc] initWithName:@"default" line:2 column:9];
    SSDReference* fooDecl = [[SSDReference alloc] initWithName:@"Foo" line:1 column:7];

    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SSDSourceKit new]
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    dataStore.obfuscatedNames[@"Foo"] = @"AAAAA";
    dataStore.obfuscatedNames[@"default"] = @"BBBBB";

    NSString* obfuscatedFile = [obfuscator getObfuscatedFile:file withReferences:@[fooDecl,
                                                                                   defaultDecl,
                                                                                   fooDecl,
                                                                                   fooDecl,
                                                                                   fooDecl]];

    XCTAssertEqualObjects(obfuscatedFile, @"class AAAAA {\n"
                                          @"    let BBBBB = 3\n"
                                          @"}");
}

@end
