#import "SourceKitUID.h"

@implementation SourceKitUID

+ (NSString*)swiftLanguagePrefix {
    return @"source.lang.swift";
}

+ (instancetype)kindId {
    return [[SourceKitUID alloc] initWithString:@"key.kind"];
}

+ (instancetype)nameId {
    return [[SourceKitUID alloc] initWithString:@"key.name"];
}

+ (instancetype)usrId {
    return [[SourceKitUID alloc] initWithString:@"key.usr"];
}

+ (instancetype)receiverId {
    return [[SourceKitUID alloc] initWithString:@"key.receiver_usr"];
}

+ (instancetype)entitiesId {
    return [[SourceKitUID alloc] initWithString:@"key.entities"];
}

+ (instancetype)lineId {
    return [[SourceKitUID alloc] initWithString:@"key.line"];
}

+ (instancetype)colId {
    return [[SourceKitUID alloc] initWithString:@"key.column"];
}

+ (instancetype)relatedId {
    return [[SourceKitUID alloc] initWithString:@"key.related"];
}

+ (instancetype)sourceFileId {
    return [[SourceKitUID alloc] initWithString:@"key.sourcefile"];
}

+ (instancetype)requestId {
    return [[SourceKitUID alloc] initWithString:@"key.request"];
}

+ (instancetype)indexRequestId {
    return [[SourceKitUID alloc] initWithString:@"source.request.indexsource"];
}

+ (instancetype)compilerArgsId {
    return [[SourceKitUID alloc] initWithString:@"key.compilerargs"];
}

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _uid = sourcekitd_uid_get_from_cstr([string cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    return self;
}

- (instancetype)initWithUid:(sourcekitd_uid_t)uid {
    self = [super init];
    if (self) {
        _uid = uid;
    }
    return self;
}

- (NSString *)asString {
    const char* characters = sourcekitd_uid_get_string_ptr(self.uid);
    return [NSString stringWithCString:characters encoding:NSUTF8StringEncoding];
}

- (SourceKitDeclarationType)declarationTypeForReferenceKind {
    // A declaration is also a reference kind.
    SourceKitDeclarationType kindForDecl = [self declarationType];
    if (kindForDecl == SourceKitDeclarationTypeUnsupported) {
        return [self declarationTypeWithExpectedSuffix:@".ref."];
    } else {
        return kindForDecl;
    }
}

- (SourceKitDeclarationType)declarationType{
    return [self declarationTypeWithExpectedSuffix:@".decl."];
}

- (SourceKitDeclarationType)declarationTypeWithExpectedSuffix:(NSString*)suffix {
    NSString* prefix = [[SourceKitUID swiftLanguagePrefix] stringByAppendingString:suffix];
    NSString* kind = [self asString];
    if ([kind hasPrefix:prefix] == NO) {
        return SourceKitDeclarationTypeUnsupported;
    }
    NSString* kindSuffix = [kind substringFromIndex:[prefix length]];

    NSSet* objectSuffixes = [[NSSet alloc] initWithArray:@[@"class", @"struct"]];
    NSSet* protocolSuffixes = [[NSSet alloc] initWithArray:@[@"protocol"]];
    NSSet* methodSuffixes = [[NSSet alloc] initWithArray:@[@"function.free",
                                                           @"function.method.instance",
                                                           @"function.method.static",
                                                           @"function.method.class"]];

    if ([objectSuffixes containsObject:kindSuffix]) {
        return SourceKitDeclarationTypeObject;
    } else if ([protocolSuffixes containsObject:kindSuffix]) {
        return SourceKitDeclarationTypeProtocol;
    } else if ([methodSuffixes containsObject:kindSuffix]) {
        return SourceKitDeclarationTypeMethod;
    } else {
        return SourceKitDeclarationTypeUnsupported;
    }
}

@end
