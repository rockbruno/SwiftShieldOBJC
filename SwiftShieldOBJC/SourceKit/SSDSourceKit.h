#import <Foundation/Foundation.h>
#import "SSDFile.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSourceKitResponse;

@interface SSDSourceKit : NSObject
- (SSDSourceKitResponse*)sendSynchronousIndexRequestForFile:(SSDFile*)file
                                            compilerArgs:(NSArray*)compilerArgs;
- (void)start;
- (void)shutdown;
@end

NS_ASSUME_NONNULL_END
