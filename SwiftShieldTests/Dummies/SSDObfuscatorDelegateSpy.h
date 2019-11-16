#import <Foundation/Foundation.h>
#import "SSDObfuscatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSDObfuscatorDelegateSpy: NSObject <SSDObfuscatorDelegate>
@property (nonatomic) NSString* receivedNewContent;
@end

NS_ASSUME_NONNULL_END
