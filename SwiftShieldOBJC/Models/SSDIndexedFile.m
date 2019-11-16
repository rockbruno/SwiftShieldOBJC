#import "SSDIndexedFile.h"

@implementation SSDIndexedFile
- (instancetype)initWithFile:(SSDFile *)file andResponse:(SourceKitResponse *)response {
    self = [super init];
    if (self) {
        _file = file;
        _response = response;
    }
    return self;
}
@end
