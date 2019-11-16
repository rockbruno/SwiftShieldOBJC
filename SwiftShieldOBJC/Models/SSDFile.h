#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Object representation of an xcodeproj's file entry.
@interface SSDFile : NSObject
@property(nonatomic) NSString* path;

- (instancetype)initWithPath:(NSString*)path;

/// The name portion of the file's path.
- (NSString*)name;

/// Returns the disk contents of the file.
- (NSString*)read:(NSError * _Nullable *)error;

/// Writes contents to the file.
- (void)writeContents:(NSString*)contents error:(NSError * _Nullable *)error;
@end

@interface SSDFile (NSCopying) <NSCopying>
@end

NS_ASSUME_NONNULL_END
