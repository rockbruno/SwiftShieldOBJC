#import <Foundation/Foundation.h>
#import "SSDFile.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSourceKitResponse;

/// A wrapper for sending requests to Apple's sourcekitd.framework.
@interface SSDSourceKit : NSObject

/// Uses SourceKit to index a file.
///
/// - Parameters:
///   - file: The file to index.
///   - compilerArgs: The compiler args to send to SourceKit.
- (SSDSourceKitResponse*)sendSynchronousIndexRequestForFile:(SSDFile*)file
                                            compilerArgs:(NSArray*)compilerArgs;

/// Starts SourceKit.
- (void)start;

/// Shutsdown a previously started SourceKit daemon.
- (void)shutdown;
@end

NS_ASSUME_NONNULL_END
