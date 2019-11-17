#import "SSDSchemeInfoProviderMock.h"

@implementation SSDSchemeInfoProviderMock

@synthesize projectFile;
@synthesize schemeName;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldFail = NO;
    }
    return self;
}

- (nonnull NSArray<SSDModule *> *)getModulesFromProject:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if (self.shouldFail) {
        *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@""}];;
    }
    return @[];
}

@end
