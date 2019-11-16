#import <XCTest/XCTest.h>
#import "SSDFile.h"

@interface SSDFileTests: XCTestCase
@end

@implementation SSDFileTests

- (NSString*)temporaryFilePathForFile:(NSString*)name {
    NSString* directory = NSTemporaryDirectory();
    return [[directory stringByAppendingString:@"/"] stringByAppendingString:name];
}

- (void)test_read_readsFile {
    NSString* tempFile = @"ssdFileRead.txt";
    NSString* contents = @"testContents";
    NSString* path = [self temporaryFilePathForFile: tempFile];
    SSDFile* file = [[SSDFile alloc] initWithPath:path];

    [contents writeToFile:path atomically:false encoding:NSUTF8StringEncoding error:nil];

    NSError* error;
    NSString* readContents = [file read:&error];
    if (error) {
        XCTFail(@"Reading failed.");
    } else {
        XCTAssertEqualObjects(readContents, contents);
    }
}

- (void)test_write_writesContentsToFile {
    NSString* tempFile = @"ssdFileWrite.txt";
    NSString* contents = @"writtenContents";
    NSString* path = [self temporaryFilePathForFile: tempFile];
    SSDFile* file = [[SSDFile alloc] initWithPath:path];

    NSError* error;
    [file writeContents:contents error:&error];

    NSString* readContents = [file read:nil];
    if (error) {
        XCTFail(@"Writing failed.");
    } else {
        XCTAssertEqualObjects(readContents, contents);
    }
}

@end
