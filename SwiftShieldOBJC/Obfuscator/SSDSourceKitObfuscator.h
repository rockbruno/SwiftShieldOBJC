#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"
#import "SSDLogger.h"

NS_ASSUME_NONNULL_BEGIN

@class SourceKit;
@class SSDSourceKitObfuscatorDataStore;
@class SSDReference;

@interface SSDSourceKitObfuscator: NSObject <SSDObfuscator>
- (instancetype)initWithSourceKit:(SourceKit*)sourceKit
                           logger:(SSDLogger)logger
                        dataStore:(SSDSourceKitObfuscatorDataStore*)dataStore;

- (NSString*)removeParameterInformationFromString:(NSString*)string;
- (NSString*)obfuscatedStringForString:(NSString*)string;
- (NSString*)getObfuscatedFile:(NSString*)fileString
                withReferences:(NSArray<SSDReference*>*)references;
@end

NS_ASSUME_NONNULL_END
