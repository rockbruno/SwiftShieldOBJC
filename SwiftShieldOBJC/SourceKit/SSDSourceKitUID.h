#import <Foundation/Foundation.h>
#import "sourcekitd.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SSDSourceKitDeclarationTypeUnsupported,
    SSDSourceKitDeclarationTypeObject,
    SSDSourceKitDeclarationTypeProtocol,
    SSDSourceKitDeclarationTypeMethod,
    SSDSourceKitDeclarationTypeProperty
} SSDSourceKitDeclarationType;

@interface SSDSourceKitUID : NSObject
@property (nonatomic) sourcekitd_uid_t uid;

+ (instancetype)kindId;
+ (instancetype)nameId;
+ (instancetype)usrId;
+ (instancetype)receiverId;
+ (instancetype)entitiesId;
+ (instancetype)lineId;
+ (instancetype)colId;
+ (instancetype)relatedId;
+ (instancetype)sourceFileId;
+ (instancetype)requestId;
+ (instancetype)indexRequestId;
+ (instancetype)compilerArgsId;

- (instancetype)initWithString:(NSString*)string;
- (instancetype)initWithUid:(sourcekitd_uid_t)uid;
- (NSString*)asString;
- (SSDSourceKitDeclarationType)declarationType;
- (SSDSourceKitDeclarationType)declarationTypeForReferenceKind;
@end

NS_ASSUME_NONNULL_END
