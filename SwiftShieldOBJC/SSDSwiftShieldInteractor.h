#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDXcodeSchemeInformationProvider;
@class SSDModule;
@protocol SSDSwiftShieldInteractorDelegate;

@protocol SSDSwiftShieldInteractorProtocol

@property (weak, nonatomic) id<SSDSwiftShieldInteractorDelegate> delegate;

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

/// Coordinates requests sent from a SwiftShield controller to obfuscation worker classes.
@interface SSDSwiftShieldInteractor: NSObject <SSDSwiftShieldInteractorProtocol>

- (instancetype)initWithSchemeInformationProvider:(SSDXcodeSchemeInformationProvider*)schemeInformationProvider
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

@protocol SSDSwiftShieldInteractorDelegate

/// A delegate method that indicates that retrieving targets from an Xcode project failed.
///
/// - Parameters:
///   - error: The thrown error.
- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToRetrieveModulesWithError:(NSError*)error;

/// A delegate method called when targets were successfully retrieved from Xcode.
///
/// - Parameters:
///   - modules: The retrieved modules.
- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor retrievedModules:(NSArray<SSDModule*>*)modules;

/// A delegate method that indicates that obfuscating a file failed.
/// When a file fails to obfuscate, the entire obfuscation process is halted.
///
/// - Parameters:
///   - error: The thrown error.
- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToObfuscateWithError:(NSError*)error;

/// A delegate method called when a file's contents are successfully obfuscated.
///
/// - Parameters:
///   - file: The obfuscated file.
///   - newContents: The new obfuscated contents of the file.
/// - Returns: A boolean indicating if the obfuscation process should stop, for example if saving the file fails.
- (BOOL)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor
      didObfuscate:(SSDFile*)file
       newContents:(NSString*)newContents;
@end

NS_ASSUME_NONNULL_END
