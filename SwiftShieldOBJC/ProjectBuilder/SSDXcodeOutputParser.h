#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;

/// A worker that specializes in parsing raw build logs from Xcode.
@interface SSDXcodeOutputParser : NSObject
- (instancetype)initWithLogger:(SSDLoggerProtocol)logger;

/// Parses raw outputs from Xcode to an array of `SSDModule`s.
///
/// - Parameters:
///   - output: The output from Xcode to parse modules from.
- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output;
@end

NS_ASSUME_NONNULL_END
