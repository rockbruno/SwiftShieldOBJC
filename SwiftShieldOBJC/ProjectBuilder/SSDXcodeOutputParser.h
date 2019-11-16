#import <Foundation/Foundation.h>
#import "SSDLogger.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDModule;

@interface SSDXcodeOutputParser : NSObject
- (instancetype)initWithLogger:(SSDLogger)logger;
- (NSArray<SSDModule*>*)parseModulesFromOutput:(NSString*)output;
@end

NS_ASSUME_NONNULL_END
