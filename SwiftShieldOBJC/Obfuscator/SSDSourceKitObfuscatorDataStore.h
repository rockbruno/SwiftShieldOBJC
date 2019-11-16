#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDIndexedFile;

@interface SSDSourceKitObfuscatorDataStore: NSObject

@property (nonatomic) NSMutableSet* processedUsrs;
@property (nonatomic) NSMutableDictionary* obfuscatedNames;
@property (nonatomic) NSMutableDictionary* usrRelationDictionary;
@property (nonatomic) NSMutableArray<SSDIndexedFile*>* indexedFiles;

@end

NS_ASSUME_NONNULL_END
