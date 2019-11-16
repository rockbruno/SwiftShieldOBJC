#import <XCTest/XCTest.h>
#import "SSDRegex.h"

@interface SSDRegexTests: XCTestCase
@end

@implementation SSDRegexTests

- (void)test_regexMatches {
    NSString* text = @"A text";

    NSArray<NSString*>* results = [SSDRegex matchesForRegex:@"[^ ]" inText:text];
    NSArray* expected = @[@"A", @"t", @"e", @"x", @"t"];
    XCTAssertEqualObjects(results, expected);

    results = [SSDRegex matchesForRegex:@".* te" inText:text];
    XCTAssertEqualObjects(results, @[@"A te"]);
}

- (void)test_regex_firstMatch {
    NSString* text = @"A text";

    NSString* result = [SSDRegex firstMatchForRegex:@"[^ ]" inText:text];
    XCTAssertEqualObjects(result, @"A");

    result = [SSDRegex firstMatchForRegex:@".* te" inText:text];
    XCTAssertEqualObjects(result, @"A te");
}

@end
