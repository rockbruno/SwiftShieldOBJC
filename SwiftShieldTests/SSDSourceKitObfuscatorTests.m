#import <XCTest/XCTest.h>
#import "SourceKit.h"
#import "SSDSourceKitObfuscator.h"
#import "SSDDummyLogger.h"
#import "SSDSourceKitObfuscatorDataStore.h"
#import "SSDModule.h"
#import "SSDFile.h"
#import "SSDIndexedFile.h"
#import "SSDReference.h"

@interface SSDSourceKitObfuscatorTests: XCTestCase
@end

@implementation SSDSourceKitObfuscatorTests

- (NSString*)temporaryFilePathForFile:(NSString*)name {
    NSString* directory = NSTemporaryDirectory();
    return [directory stringByAppendingString:name];
}

- (void)test_moduleRegistration {
    SourceKit* sourceKit = [SourceKit new];
    [sourceKit start];
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];

    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    NSString* mockPath = @"/Users/bruno.rocha/Desktop/bla.swift";//[self temporaryFilePathForFile:@"moduleRegistration.swift"];
    SSDFile* mockFile = [[SSDFile alloc] initWithPath:mockPath];
//    [mockFile writeContents:@"class Foo {}" error:nil];

    SSDModule* mockModule = [[SSDModule alloc] initWithName:@"MockModule"
                                                sourceFiles:@[mockFile]
                                          compilerArguments:@[@"-module-name",
                                                              @"MockModule",
                                                              @"-Onone",
                                                              @"-sdk",
                                                             @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.1.sdk",
                                                              @"-swift-version",
                                                              @"4",
                                                              @"-c",
                                                              @"-j12",
                                                              mockPath]];

    [obfuscator registerModuleForObfuscation:mockModule];

    XCTAssertEqualObjects(dataStore.processedUsrs, @[]);
    XCTAssertEqualObjects(dataStore.indexedFiles.firstObject.file, mockFile);

}

- (void)test_removeParameterInformationFromString {
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SourceKit new]
                                                                                    logger:[SSDDummyLogger new]
                                                                                 dataStore:dataStore];

    NSString* methodName = @"fooFunc(parameter:parameter2:)";
    XCTAssertEqualObjects([obfuscator removeParameterInformationFromString:methodName], @"fooFunc");

    NSString* propertyName = @"barProp";
    XCTAssertEqualObjects([obfuscator removeParameterInformationFromString:propertyName], @"barProp");
}

- (void)test_obfuscatedString_cachesSimilarStrings {
    SSDSourceKitObfuscatorDataStore* dataStore = [SSDSourceKitObfuscatorDataStore new];
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SourceKit new]
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
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SourceKit new]
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
    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:[SourceKit new]
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
