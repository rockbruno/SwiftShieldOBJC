#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSDReference : NSObject
@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSInteger line;
@property (readonly, nonatomic) NSInteger column;

- (instancetype)initWithName:(NSString*)name
                        line:(NSInteger)line 
                      column:(NSInteger)column;
- (NSComparisonResult)compare:(SSDReference*)otherObject;
@end

NS_ASSUME_NONNULL_END
