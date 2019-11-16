#import "SSDFile.h"

@interface SSDFile (Equality)
@end

@implementation SSDFile

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (NSString*)name {
    return [[self path] lastPathComponent];
}

- (NSString*)read:(NSError * _Nullable *)error {
    return [NSString stringWithContentsOfFile:[self path] encoding:NSUTF8StringEncoding error:error];
}

- (void)writeContents:(NSString*)contents error:(NSError * _Nullable *)error {
    [contents writeToFile:[self path] atomically:false encoding:NSUTF8StringEncoding error:error];
}

@end

@implementation SSDFile (Equality)

- (BOOL)isEqual:(SSDFile*)other
{
    if (other == self) {
        return YES;
    } else {
        return [self.path isEqualTo:other.path];;
    }
}

@end

@implementation SSDFile (NSCopying)

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[SSDFile alloc] initWithPath:self.path];
}

@end
