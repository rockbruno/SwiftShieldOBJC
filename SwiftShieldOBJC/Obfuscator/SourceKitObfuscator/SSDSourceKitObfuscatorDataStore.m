#import "SSDSourceKitObfuscatorDataStore.h"

@implementation SSDSourceKitObfuscatorDataStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _processedUsrs = [NSMutableSet new];
        _obfuscatedNames = [NSMutableDictionary new];
        _usrRelationDictionary = [NSMutableDictionary new];
        _indexedFiles = [NSMutableArray new];
    }
    return self;
}

@end
