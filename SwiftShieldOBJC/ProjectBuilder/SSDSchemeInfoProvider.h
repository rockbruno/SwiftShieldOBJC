#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"
#import "SSDSchemeInfoProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDModule;
@protocol SSDTaskRunnerProtocol;

@interface SSDSchemeInfoProvider: NSObject <SSDSchemeInfoProviderProtocol>
- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                       taskRunner:(id<SSDTaskRunnerProtocol>)taskRunner
                             logger:(id<SSDLoggerProtocol>)logger;
@end

@interface SSDSchemeInfoProvider (OutputParsing)
/// Parses raw outputs from Xcode to an array of `SSDModule`s.
///
/// - Parameters:
///   - output: The output from Xcode to parse modules from.
- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output;
@end

NS_ASSUME_NONNULL_END
