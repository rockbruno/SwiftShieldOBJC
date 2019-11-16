#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSourceKit;
@class SSDSourceKitObfuscatorDataStore;
@class SSDReference;

@interface SSDSourceKitObfuscator: NSObject <SSDObfuscator>
- (instancetype)initWithSourceKit:(SSDSourceKit*)sourceKit
                           logger:(SSDLoggerProtocol)logger
                        dataStore:(SSDSourceKitObfuscatorDataStore*)dataStore;

- (NSString*)removeParameterInformationFromString:(NSString*)string;
- (NSString*)obfuscatedStringForString:(NSString*)string;
- (NSString*)getObfuscatedFile:(NSString*)fileString
                withReferences:(NSArray<SSDReference*>*)references;
@end

NS_ASSUME_NONNULL_END
