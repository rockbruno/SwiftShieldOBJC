#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSDRegex: NSObject
+ (NSString*)firstMatchForRegex:(NSString*)pattern inText:(NSString*)text;
+ (NSArray<NSString*>*)matchesForRegex:(NSString*)pattern inText:(NSString*)text;
@end

NS_ASSUME_NONNULL_END
