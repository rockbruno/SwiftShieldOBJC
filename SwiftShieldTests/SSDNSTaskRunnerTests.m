#import <XCTest/XCTest.h>
#import "SSDNSTaskRunner.h"
#import "SSDTaskRunnerOutput.h"

@interface SSDNSTaskRunnerTests: XCTestCase
@end

@implementation SSDNSTaskRunnerTests

- (void)test_successfulEcho {
    SSDNSTaskRunner* runner = [SSDNSTaskRunner new];

    SSDTaskRunnerOutput* result = [runner runTaskWithCommand:@"/bin/echo" arguments:@[@"foo"]];

    XCTAssertEqualObjects(result.output, @"foo\n");
    XCTAssertEqual(result.terminationStatus, 0);
}

- (void)test_successfulLS {
    SSDNSTaskRunner* runner = [SSDNSTaskRunner new];

    SSDTaskRunnerOutput* result = [runner runTaskWithCommand:@"/bin/ls" arguments:@[]];

    XCTAssertEqualObjects(result.output, @"SwiftShieldOBJC\nSwiftShieldTests.xctest\n");
    XCTAssertEqual(result.terminationStatus, 0);
}

- (void)test_failedCommand {
    SSDNSTaskRunner* runner = [SSDNSTaskRunner new];

    SSDTaskRunnerOutput* result = [runner runTaskWithCommand:@"/bin/kill" arguments:@[@"bar"]];

    XCTAssertEqualObjects(result.output, @"kill: illegal process id: bar\n");
    XCTAssertEqual(result.terminationStatus, 2);
}
@end
