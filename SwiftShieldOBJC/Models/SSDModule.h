#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;

typedef NSArray<SSDFile*> FileArray;
typedef NSArray<NSString*> StringArray;

@interface SSDModule: NSObject
@property (nonatomic) NSString* name;
@property (nonatomic) FileArray* sourceFiles;
@property (nonatomic) StringArray* compilerArguments;

- (instancetype)initWithName:(NSString*)name
                 sourceFiles:(FileArray*)sourceFiles
           compilerArguments:(StringArray*)compilerArguments;
@end

NS_ASSUME_NONNULL_END
