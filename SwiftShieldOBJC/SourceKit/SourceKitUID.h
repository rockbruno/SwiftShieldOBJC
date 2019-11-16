#import <Foundation/Foundation.h>
#import "sourcekitd.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SourceKitDeclarationTypeUnsupported,
    SourceKitDeclarationTypeObject,
    SourceKitDeclarationTypeProtocol,
    SourceKitDeclarationTypeMethod,
    SourceKitDeclarationTypeProperty
} SourceKitDeclarationType;

@interface SourceKitUID : NSObject
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
- (SourceKitDeclarationType)declarationType;
- (SourceKitDeclarationType)declarationTypeForReferenceKind;
@end

NS_ASSUME_NONNULL_END
