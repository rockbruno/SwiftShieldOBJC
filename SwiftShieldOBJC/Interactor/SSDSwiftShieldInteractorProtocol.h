@protocol SSDSwiftShieldInteractorDelegate;
@class SSDModule;

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
