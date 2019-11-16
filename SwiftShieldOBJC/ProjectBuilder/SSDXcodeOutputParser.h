#import <Foundation/Foundation.h>
#import "SSDLoggerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;

@interface SSDXcodeOutputParser : NSObject
- (instancetype)initWithLogger:(SSDLoggerProtocol)logger;
- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output;
@end

NS_ASSUME_NONNULL_END
