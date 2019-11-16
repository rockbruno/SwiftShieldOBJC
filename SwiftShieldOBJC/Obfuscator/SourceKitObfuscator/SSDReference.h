#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The representation of a symbol reference in a Swift file.
@interface SSDReference : NSObject
@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSInteger line;
@property (readonly, nonatomic) NSInteger column;

- (instancetype)initWithName:(NSString*)name
                        line:(NSInteger)line 
                      column:(NSInteger)column;
@end

NS_ASSUME_NONNULL_END
