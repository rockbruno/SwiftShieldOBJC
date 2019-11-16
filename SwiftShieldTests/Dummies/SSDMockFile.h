#import <Foundation/Foundation.h>
#import "SSDFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDMockFile: SSDFile
@property (nonatomic) BOOL shouldFailToWrite;
@property (nonatomic) NSString* writtenContents;
@end

NS_ASSUME_NONNULL_END
