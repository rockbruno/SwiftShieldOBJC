#import "SSDMockFile.h"

@implementation SSDMockFile
- (instancetype)initWithPath:(NSString *)path
{
    self = [super initWithPath:path];
    if (self) {
        _shouldFailToWrite = NO;
        _writtenContents = @"";
    }
    return self;
}

- (void)writeContents:(NSString *)contents error:(NSError * _Nullable __autoreleasing *)error {
    if (self.shouldFailToWrite) {
        *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@""}];
    } else {
        self.writtenContents = contents;
    }
}
@end
