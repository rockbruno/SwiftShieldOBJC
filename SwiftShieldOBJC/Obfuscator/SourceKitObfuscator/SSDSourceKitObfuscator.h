#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSourceKit;
@class SSDSourceKitObfuscatorDataStore;
@class SSDReference;

/// A `SSDObfuscator` that uses SourceKit to obfuscate modules.
@interface SSDSourceKitObfuscator: NSObject <SSDObfuscatorProtocol>
- (instancetype)initWithSourceKit:(SSDSourceKit*)sourceKit
                           logger:(id<SSDLoggerProtocol>)logger
                        dataStore:(SSDSourceKitObfuscatorDataStore*)dataStore;

/// Removes arguments from a SourceKit name string.
/// Example: foo(arg1:arg2) ===> foo.
///
/// - Parameters:
///   - string: The string to act upon.
- (NSString*)removeParameterInformationFromString:(NSString*)string;

/// Generates an obfuscated version of a string.
/// If the obfuscator's `dataStore` is unmodified, calling this multiple times for the same string
/// results in the same obfuscated result.
/// Example: abc ====> fjvjf83fn3
///
/// - Parameters:
///   - string: The string to act upon.
- (NSString*)obfuscatedStringForString:(NSString*)string;

/// Obfuscates references inside an arbitrary text.
///
/// - Parameters:
///   - fileString: The string to act upon.
///   - references: The references in the file that should be obfuscated.
- (NSString*)getObfuscatedFile:(NSString*)fileString
                withReferences:(NSArray<SSDReference*>*)references;
@end

NS_ASSUME_NONNULL_END
