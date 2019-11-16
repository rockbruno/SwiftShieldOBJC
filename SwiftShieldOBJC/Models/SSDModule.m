#import "SSDModule.h"

@interface SSDModule (Equality)
@end

@implementation SSDModule

- (instancetype)initWithName:(NSString*)name
                 sourceFiles:(FileArray*)sourceFiles
           compilerArguments:(StringArray*)compilerArguments; {
    self = [super init];
    if (self) {
        _name = name;
        _sourceFiles = sourceFiles;
        _compilerArguments = compilerArguments;
    }
    return self;
}

@end

@implementation SSDModule (Equality)

- (BOOL)isEqual:(SSDModule*)other
{
    if (other == self) {
        return YES;
    } else {
        return [self.name isEqualTo:other.name] &&
               [self.sourceFiles isEqualTo:other.sourceFiles] &&
               [self.compilerArguments isEqualTo:other.compilerArguments];
    }
}

@end
