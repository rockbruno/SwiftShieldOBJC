#import <Foundation/Foundation.h>
#import "SSDFile.h"

NS_ASSUME_NONNULL_BEGIN

@class SourceKitResponse;

@interface SourceKit : NSObject
- (SourceKitResponse*)sendSynchronousIndexRequestForFile:(SSDFile*)file
                                            compilerArgs:(NSArray*)compilerArgs;
- (void)start;
- (void)shutdown;
@end

NS_ASSUME_NONNULL_END
