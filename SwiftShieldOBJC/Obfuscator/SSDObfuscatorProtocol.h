#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;
@class SSDFile;
@protocol SSDObfuscatorDelegate;

/// An `SSDObfuscatorProtocol` abstracts the process of obfuscating files from a module.
/// Modules are registered to the obfuscator, which can be used to pre-process information inside the obfuscator.
/// After all modules were registered, the `SSDObfuscator` can start sending events to the assigned delegate.
@protocol SSDObfuscatorProtocol

@property (weak, nonatomic) id<SSDObfuscatorDelegate> delegate;

/// Registers a module to be obfuscated.
///
/// - Parameters:
///   - module: The module to register.
- (void)registerModuleForObfuscation:(SSDModule*)module;

/// Obfuscates the registered modules.
/// To register modules for obfuscation, call `registerModuleForObfuscation`.
/// During obfuscation, each obfuscated file will result in a single delegate call indicating the status of the obfuscation.
- (void)obfuscate;

@end

/// A delegate that receives events from a `SSDObfuscator`.
@protocol SSDObfuscatorDelegate
/// Delegate method called when a file was successfully obfuscated.
///
/// - Parameters:
///   - obfuscator: The obfuscator.
///   - file: The file that was obfuscated.
///   - newContent: The obfuscated contents of the file.
/// - Returns: A boolean indicating if the obfuscation process should stop, for example if saving the file fails.
- (BOOL)obfuscator:(id<SSDObfuscatorProtocol>)obfuscator
  didObfuscateFile:(SSDFile*)file
        newContent:(NSString*)newContent;

/// Delegate method called when obfuscating a file fails.
/// 
/// If the obfuscation fails for a single file, the entire obfuscation process will stop.
/// - Parameters:
///   - obfuscator: The obfuscator.
///   - file: The file that failed to be obfuscated.
///   - error: The thrown error.
- (void)obfuscator:(id<SSDObfuscatorProtocol>)obfuscator
didFailToObfuscateFile:(SSDFile*)file
             withError:(NSError*)error;
@end

NS_ASSUME_NONNULL_END
