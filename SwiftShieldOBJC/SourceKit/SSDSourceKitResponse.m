#import "SSDSourceKitResponse.h"
#import "sourcekitd.h"
#import "SSDSourceKitUID.h"

@interface SSDSourceKitResponseDictionary ()
@property (nonatomic) sourcekitd_variant_t dict;
// The lifetime of this sourcekitd_variant_t is tied to the response it came
// from, so keep a reference to the response too.
@property (nonatomic) SSDSourceKitResponse* context;
@end

@implementation SSDSourceKitResponseDictionary
- (instancetype)initWithDictionary:(sourcekitd_variant_t)dict andContext:(SSDSourceKitResponse*)context {
    self = [super init];
    if (self) {
        _dict = dict;
        _context = context;
    }
    return self;
}

- (NSString *)getString:(SSDSourceKitUID *)uid {
    const char* value = sourcekitd_variant_dictionary_get_string(self.dict, uid.uid);
    if (!value) {
        return NULL;
    }
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

- (NSInteger)getInt:(SSDSourceKitUID *)uid {
    int64_t value = sourcekitd_variant_dictionary_get_int64(self.dict, uid.uid);
    return value;
}

- (SSDSourceKitUID *)getUid:(SSDSourceKitUID *)uid {
    sourcekitd_uid_t value = sourcekitd_variant_dictionary_get_uid(self.dict, uid.uid);
    return [[SSDSourceKitUID alloc] initWithUid: value];
}
@end

@interface SSDSourceKitResponseVariant ()
@property (nonatomic) sourcekitd_variant_t value;
// The lifetime of this sourcekitd_variant_t is tied to the response it came
// from, so keep a reference to the response too.
@property (nonatomic) SSDSourceKitResponse* context;
@end

@implementation SSDSourceKitResponseVariant
- (instancetype)initWithVariant:(sourcekitd_variant_t)value andContext:(SSDSourceKitResponse*)context {
    self = [super init];
    if (self) {
        _value = value;
        _context = context;
    }
    return self;
}

- (SSDSourceKitResponseDictionary *)dictionary {
    return [[SSDSourceKitResponseDictionary alloc] initWithDictionary:self.value andContext:self.context];
}

- (void)recurseOverUid:(SSDSourceKitUID *)uid block:(ResponseRecursion)block {
    sourcekitd_uid_t rawUid = uid.uid;
    sourcekitd_variant_t children = sourcekitd_variant_dictionary_get_value(self.value, rawUid);
    if (sourcekitd_variant_get_type(children) != SOURCEKITD_VARIANT_TYPE_ARRAY) {
        return;
    }
    sourcekitd_variant_array_apply(children, ^bool(size_t index, sourcekitd_variant_t value) {
        SSDSourceKitResponseVariant* variant = [[SSDSourceKitResponseVariant alloc] initWithVariant:value andContext:self.context];
        block(variant);
        [variant recurseOverUid:uid block:block];
        return true;
    });
}

- (BOOL)isEqualTo:(SSDSourceKitResponseVariant*)otherVariant {
    return self.value.data[0] == otherVariant.value.data[0] &&
           self.value.data[1] == otherVariant.value.data[1] &&
           self.value.data[2] == otherVariant.value.data[2];
}

@end

@interface SSDSourceKitResponse () {
    sourcekitd_response_t _response;
}
@end

@implementation SSDSourceKitResponse
- (instancetype)initWithSourceKitResponse:(sourcekitd_response_t)response
{
    self = [super init];
    if (self) {
        _response = response;
    }
    return self;
}

- (SSDSourceKitResponseVariant*)variant {
    sourcekitd_variant_t value = sourcekitd_response_get_value(_response);
    return [[SSDSourceKitResponseVariant alloc] initWithVariant:value andContext:self];
}

- (void)recurseOverUid:(SSDSourceKitUID *)uid block:(ResponseRecursion)block {
    [[self variant] recurseOverUid:uid block:block];
}

- (NSString *)responseDescription {
    char* utf8Str = sourcekitd_response_description_copy(_response);
    NSString* result = [[NSString alloc] initWithCString:utf8Str encoding:NSUTF8StringEncoding];
    free(utf8Str);
    return result;
}

- (void)dealloc {
    sourcekitd_response_dispose(_response);
}
@end
