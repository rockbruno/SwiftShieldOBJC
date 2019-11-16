#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLogger.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDXcodeSchemeInformationProvider;
@class SSDModule;
@protocol SSDSwiftShieldInteractorDelegate;

@interface SSDSwiftShieldInteractor: NSObject
@property (weak, nonatomic) id<SSDSwiftShieldInteractorDelegate> delegate;

- (instancetype)initWithSchemeInformationProvider:(SSDXcodeSchemeInformationProvider*)schemeInformationProvider
                                           logger:(SSDLogger)logger
                                        obfuscator:(SSDObfuscatorProtocol)obfuscator;
- (void)getModulesFromProject;
- (void)obfuscateModules:(NSArray<SSDModule*>*)modules;
@end

@protocol SSDSwiftShieldInteractorDelegate
- (void)interactor:(SSDSwiftShieldInteractor*)interactor failedToRetrieveModulesWithError:(NSError*)error;
- (void)interactor:(SSDSwiftShieldInteractor*)interactor retrievedModules:(NSArray<SSDModule*>*)modules;
- (void)interactor:(SSDSwiftShieldInteractor*)interactor failedToObfuscateWithError:(NSError*)error;
- (BOOL)interactor:(SSDSwiftShieldInteractor*)interactor
      didObfuscate:(SSDFile*)file
       newContents:(NSString*)newContents;
@end

NS_ASSUME_NONNULL_END
