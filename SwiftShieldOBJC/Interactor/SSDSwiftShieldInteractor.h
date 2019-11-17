#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLoggerProtocol.h"
#import "SSDSwiftShieldInteractorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;
@protocol SSDSwiftShieldInteractorDelegate;
@protocol SSDSchemeInfoProviderProtocol;
@protocol SSDSwiftShieldInteractorProtocol;

/// Coordinates requests sent from a SwiftShield controller to obfuscation worker classes.
@interface SSDSwiftShieldInteractor: NSObject <SSDSwiftShieldInteractorProtocol>

- (instancetype)initWithSchemeInfoProvider:(id<SSDSchemeInfoProviderProtocol>)schemeInfoProvider
                                    logger:(id<SSDLoggerProtocol>)logger
                                obfuscator:(id<SSDObfuscatorProtocol>)obfuscator;

/// Retrieves .pbxproj targets from the relevant Xcode project.
/// After the interactor finishes retrieving the modules, the result is sent via the delegate.
- (void)getModulesFromProject;

/// Starts the obfuscation process for a set of modules.
/// During the obfuscation process, the status each individual file is sent to the delegate.
///
/// - Parameters:
///   - modules: The modules to obfuscate.
- (void)obfuscateModules:(NSArray<SSDModule*>*)modules;
@end

@interface SSDSwiftShieldInteractor (ObfuscatorDelegate) <SSDObfuscatorDelegate>
@end

NS_ASSUME_NONNULL_END
