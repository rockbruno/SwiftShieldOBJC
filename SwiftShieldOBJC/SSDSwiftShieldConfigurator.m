#import <Foundation/Foundation.h>
#import "SSDSwiftShieldConfigurator.h"
#import "SSDSwiftShieldController.h"
#import "SSDNSLogLogger.h"
#import "SSDFile.h"
#import "SSDSchemeInfoProvider.h"
#import "SSDSourceKit.h"
#import "SSDSourceKitObfuscator.h"
#import "SSDSourceKitObfuscatorDataStore.h"
#import "SSDSwiftShieldInteractor.h"
#import "SSDNSTaskRunner.h"

@implementation SSDSwiftShieldConfigurator
+ (SSDSwiftShieldController *)resolveFromProject:(NSString*)projectFile scheme:(NSString*)scheme {
    SSDFile* file = [[SSDFile alloc] initWithPath:projectFile];

    SSDNSLogLogger* logger = [SSDNSLogLogger new];
    SSDNSTaskRunner* taskRunner = [SSDNSTaskRunner new];
    SSDSchemeInfoProvider* schemeInfo = [[SSDSchemeInfoProvider alloc]
                                                     initWithProjectFile:file
                                                              schemeName:scheme
                                                              taskRunner:taskRunner
                                                                  logger:logger];

    SSDSourceKit* sourceKit = [SSDSourceKit new];

    SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                    logger:logger
                                                                                 dataStore:[SSDSourceKitObfuscatorDataStore new]];

    SSDSwiftShieldInteractor* interactor = [[SSDSwiftShieldInteractor alloc] initWithSchemeInfoProvider:schemeInfo
                                                                                                 logger:logger
                                                                                             obfuscator:obfuscator];

    return [[SSDSwiftShieldController alloc] initWithInterator:interactor logger:logger];
}
@end
