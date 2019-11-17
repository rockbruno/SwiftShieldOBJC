#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"
#import "SSDSchemeInfoProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDModule;
@class SSDXcodeOutputParser;

@interface SSDSchemeInfoProvider : NSObject <SSDSchemeInfoProviderProtocol>

- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                  buildOutputParser:(SSDXcodeOutputParser*)outputParser
                             logger:(id<SSDLoggerProtocol>)logger;

/// The `NSTask` that represents the xcodebuild operation used for extracting modules.
- (NSTask*)buildTask;

/// Parses raw outputs from Xcode to an array of `SSDModule`s.
///
/// - Parameters:
///   - output: The output from Xcode to parse modules from.
///   - terminationStatus: The status code from the operation that resulted in the said output.
///   - error: A pointer to an error that is filled when the operation fails.
- (NSArray<SSDModule*>*_Nonnull)parseModulesFromOutput:(NSString * _Nullable)output
                                     terminationStatus:(NSInteger)statusCode
                                                 error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
