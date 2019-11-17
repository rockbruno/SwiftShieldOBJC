#import <Foundation/Foundation.h>
#import "sourcekitd.h"

NS_ASSUME_NONNULL_BEGIN

@class SSDSourceKitUID;
@class SSDSourceKitResponseVariant;

@interface SSDSourceKitResponseDictionary : NSObject
- (SSDSourceKitUID*)getUid:(SSDSourceKitUID*)uid;
- (NSString*)getString:(SSDSourceKitUID*)uid;
- (NSInteger)getInt:(SSDSourceKitUID *)uid;
@end

////////////////////////////////////////////////////////

typedef void(^ResponseRecursion)(SSDSourceKitResponseVariant*);

@interface SSDSourceKitResponseVariant : NSObject
- (SSDSourceKitResponseDictionary*)dictionary;
- (void)recurseOverUid:(SSDSourceKitUID *)uid block:(ResponseRecursion)block;
@end

////////////////////////////////////////////////////////

@interface SSDSourceKitResponse : NSObject
- (instancetype)initWithSourceKitResponse:(sourcekitd_response_t)response;
- (void)recurseOverUid:(SSDSourceKitUID*)uid block:(ResponseRecursion)block;
- (NSString*)responseDescription;
@end

NS_ASSUME_NONNULL_END
