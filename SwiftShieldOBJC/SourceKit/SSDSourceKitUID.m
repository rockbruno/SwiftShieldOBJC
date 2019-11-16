#import "SSDSourceKitUID.h"

@implementation SSDSourceKitUID

+ (NSString*)swiftLanguagePrefix {
    return @"source.lang.swift";
}

+ (instancetype)kindId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.kind"];
}

+ (instancetype)nameId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.name"];
}

+ (instancetype)usrId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.usr"];
}

+ (instancetype)receiverId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.receiver_usr"];
}

+ (instancetype)entitiesId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.entities"];
}

+ (instancetype)lineId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.line"];
}

+ (instancetype)colId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.column"];
}

+ (instancetype)relatedId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.related"];
}

+ (instancetype)sourceFileId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.sourcefile"];
}

+ (instancetype)requestId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.request"];
}

+ (instancetype)indexRequestId {
    return [[SSDSourceKitUID alloc] initWithString:@"source.request.indexsource"];
}

+ (instancetype)compilerArgsId {
    return [[SSDSourceKitUID alloc] initWithString:@"key.compilerargs"];
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

- (SSDSourceKitDeclarationType)declarationTypeForReferenceKind {
    // A declaration is also a reference kind.
    SSDSourceKitDeclarationType kindForDecl = [self declarationType];
    if (kindForDecl == SSDSourceKitDeclarationTypeUnsupported) {
        return [self declarationTypeWithExpectedSuffix:@".ref."];
    } else {
        return kindForDecl;
    }
}

- (SSDSourceKitDeclarationType)declarationType{
    return [self declarationTypeWithExpectedSuffix:@".decl."];
}

- (SSDSourceKitDeclarationType)declarationTypeWithExpectedSuffix:(NSString*)suffix {
    NSString* prefix = [[SSDSourceKitUID swiftLanguagePrefix] stringByAppendingString:suffix];
    NSString* kind = [self asString];
    if ([kind hasPrefix:prefix] == NO) {
        return SSDSourceKitDeclarationTypeUnsupported;
    }
    NSString* kindSuffix = [kind substringFromIndex:[prefix length]];

    NSSet* objectSuffixes = [[NSSet alloc] initWithArray:@[@"class", @"struct"]];
    NSSet* protocolSuffixes = [[NSSet alloc] initWithArray:@[@"protocol"]];
    NSSet* methodSuffixes = [[NSSet alloc] initWithArray:@[@"function.free",
                                                           @"function.method.instance",
                                                           @"function.method.static",
                                                           @"function.method.class"]];

    if ([objectSuffixes containsObject:kindSuffix]) {
        return SSDSourceKitDeclarationTypeObject;
    } else if ([protocolSuffixes containsObject:kindSuffix]) {
        return SSDSourceKitDeclarationTypeProtocol;
    } else if ([methodSuffixes containsObject:kindSuffix]) {
        return SSDSourceKitDeclarationTypeMethod;
    } else {
        return SSDSourceKitDeclarationTypeUnsupported;
    }
}

@end
