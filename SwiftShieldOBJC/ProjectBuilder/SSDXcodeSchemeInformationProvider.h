#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDModule;
@class SSDXcodeOutputParser;

@interface SSDXcodeSchemeInformationProvider : NSObject
- (instancetype)initWithProjectFile:(SSDFile*)projectFile
                         schemeName:(NSString* )schemeName
                  buildOutputParser:(SSDXcodeOutputParser*)outputParser
                             logger:(SSDLoggerProtocol)logger;
- (NSArray<SSDModule*>*)getModulesFromProject:(NSError * _Nullable *)error;

- (NSTask*)buildTask;

- (NSArray<SSDModule*>*_Nonnull)parseModulesFromOutput:(NSString * _Nullable)output
                                     terminationStatus:(NSInteger)statusCode
                                                 error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
