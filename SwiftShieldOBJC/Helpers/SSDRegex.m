#import "SSDRegex.h"

@implementation SSDRegex
+ (NSString*)firstMatchForRegex:(NSString*)pattern inText:(NSString*)text {
    return [[self matchesForRegex:pattern inText:text] firstObject];
}

+ (NSArray<NSString*>*)matchesForRegex:(NSString*)pattern inText:(NSString*)text {
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray<NSTextCheckingResult*>* results = [regex matchesInString:text options:0 range: NSMakeRange(0, [text length])];
    NSMutableArray* stringResults = [NSMutableArray new];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stringResults addObject:[text substringWithRange:obj.range]];
    }];
    return stringResults;
}
@end
