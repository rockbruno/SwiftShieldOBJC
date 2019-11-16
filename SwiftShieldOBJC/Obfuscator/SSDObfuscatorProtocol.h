#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;
@class SSDFile;
@protocol SSDObfuscatorDelegate;

@protocol SSDObfuscator
@property (weak, nonatomic) id<SSDObfuscatorDelegate> delegate;

- (void)registerModuleForObfuscation:(SSDModule*)module;
- (void)obfuscate;
@end

typedef id<SSDObfuscator> SSDObfuscatorProtocol;

@protocol SSDObfuscatorDelegate
- (BOOL)obfuscator:(SSDObfuscatorProtocol)obfuscator
  didObfuscateFile:(SSDFile*)file
        newContent:(NSString*)newContent;
- (void)obfuscator:(SSDObfuscatorProtocol)obfuscator
didFailToObfuscateFile:(SSDFile*)file
             withError:(NSError*)error;
@end

NS_ASSUME_NONNULL_END
