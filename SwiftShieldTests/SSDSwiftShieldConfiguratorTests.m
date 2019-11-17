#import <XCTest/XCTest.h>
#import "SSDSwiftShieldConfigurator.h"
#import "SSDSwiftShieldController.h"
#import "SSDSwiftShieldInteractor.h"
#import "SSDSchemeInfoProvider.h"
#import "SSDSourceKitObfuscator.h"
#import "SSDFile.h"
#import "SSDNSTaskRunner.h"

@interface SSDSwiftShieldConfiguratorTests: XCTestCase
@end

@implementation SSDSwiftShieldConfiguratorTests

- (void)test_configurator_hasCorrectDependencies {
    SSDSwiftShieldController* controller = [SSDSwiftShieldConfigurator resolveFromProject:@"foo.xcodeproj" scheme:@"bar"];

    id interactor = [controller valueForKey:@"interactor"];
    XCTAssertTrue([interactor isKindOfClass:[SSDSwiftShieldInteractor class]]);

    id schemeInfoProvider = [interactor valueForKey:@"schemeInfoProvider"];
    XCTAssertTrue([schemeInfoProvider isKindOfClass:[SSDSchemeInfoProvider class]]);

    id projectFile = [schemeInfoProvider valueForKey:@"projectFile"];
    id schemeName = [schemeInfoProvider valueForKey:@"schemeName"];
    id taskRunner = [schemeInfoProvider valueForKey:@"taskRunner"];

    XCTAssertTrue([projectFile isKindOfClass:[SSDFile class]]);
    XCTAssertEqualObjects([projectFile valueForKey:@"path"], @"foo.xcodeproj");
    XCTAssertEqualObjects(schemeName, @"bar");

    XCTAssertTrue([taskRunner isKindOfClass:[SSDNSTaskRunner class]]);

    id obfuscator = [interactor valueForKey:@"obfuscator"];
    XCTAssertTrue([obfuscator isKindOfClass:[SSDSourceKitObfuscator class]]);
}

@end
