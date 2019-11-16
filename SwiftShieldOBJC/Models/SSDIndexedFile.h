#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDSourceKitResponse;

@interface SSDIndexedFile: NSObject
@property (readonly, nonatomic) SSDFile* file;
@property (readonly, nonatomic) SSDSourceKitResponse* response;

- (instancetype)initWithFile:(SSDFile*)file andResponse:(SSDSourceKitResponse*)response;
@end

NS_ASSUME_NONNULL_END
