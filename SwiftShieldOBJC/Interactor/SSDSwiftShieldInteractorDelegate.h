@protocol SSDSwiftShieldInteractorProtocol;
@class SSDModule;
@class SSDFile;

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
