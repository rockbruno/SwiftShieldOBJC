#import <Foundation/Foundation.h>
#import "SSDReference.h"

@implementation SSDReference
- (instancetype)initWithName:(NSString *)name
                        line:(NSInteger)line
                      column:(NSInteger)column
{
    self = [super init];
    if (self) {
        _name = name;
        _line = line;
        _column = column;
    }
    return self;
}

- (NSComparisonResult)compare:(SSDReference*)otherObject {
    if (self.line != otherObject.line) {
        return self.line < otherObject.line ? NSOrderedAscending : NSOrderedDescending;
    } else if (self.column != otherObject.column) {
        return self.column < otherObject.column ? NSOrderedAscending : NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}
@end
