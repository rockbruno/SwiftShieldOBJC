#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDModule;
@class SSDXcodeOutputParser;

/// A worker that extracts information from a Xcode project, relevant to a specific scheme.
@interface SSDXcodeSchemeInformationProvider : NSObject

- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                  buildOutputParser:(SSDXcodeOutputParser*)outputParser
                             logger:(SSDLoggerProtocol)logger;

/// Retrieves .pbxproj targets from the relevant Xcode project by building it.
///
/// - Parameters:
///   - error: A pointer to an error that is filled when the operation fails.
- (NSArray<SSDModule*>*)getModulesFromProject:(NSError * _Nullable *)error;

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
