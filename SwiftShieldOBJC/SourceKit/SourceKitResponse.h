#import <Foundation/Foundation.h>
#import "sourcekitd.h"

NS_ASSUME_NONNULL_BEGIN

@class SourceKitUID;
@class SourceKitResponseVariant;

@interface SourceKitResponseDictionary : NSObject
- (SourceKitUID*)getUid:(SourceKitUID*)uid;
- (NSString*)getString:(SourceKitUID*)uid;
- (NSInteger)getInt:(SourceKitUID *)uid;
@end

////////////////////////////////////////////////////////

typedef void(^ResponseRecursion)(SourceKitResponseVariant*);

@interface SourceKitResponseVariant : NSObject
- (SourceKitResponseDictionary*)dictionary;
- (void)recurseOverUid:(SourceKitUID *)uid block:(ResponseRecursion)block;
- (BOOL)isEqualTo:(SourceKitResponseVariant*)otherVariant;
@end

////////////////////////////////////////////////////////

@interface SourceKitResponse : NSObject
- (instancetype)initWithSourceKitResponse:(sourcekitd_response_t)response;
- (void)recurseOverUid:(SourceKitUID*)uid block:(ResponseRecursion)block;
- (NSString*)responseDescription;
@end

NS_ASSUME_NONNULL_END
