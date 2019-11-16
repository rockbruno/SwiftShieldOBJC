#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SourceKitResponse;

@interface SSDIndexedFile: NSObject
@property (readonly, nonatomic) SSDFile* file;
@property (readonly, nonatomic) SourceKitResponse* response;

- (instancetype)initWithFile:(SSDFile*)file andResponse:(SourceKitResponse*)response;
@end

NS_ASSUME_NONNULL_END
