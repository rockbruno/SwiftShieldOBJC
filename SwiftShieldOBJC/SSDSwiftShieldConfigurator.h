#import <Foundation/Foundation.h>

@class SSDSwiftShieldController;

NS_ASSUME_NONNULL_BEGIN

@interface SSDSwiftShieldConfigurator : NSObject
+(SSDSwiftShieldController*)resolveFromProject:(NSString*)projectFile scheme:(NSString*)scheme;
@end

NS_ASSUME_NONNULL_END
