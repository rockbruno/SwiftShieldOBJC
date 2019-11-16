#import "SourceKit.h"
#import "sourcekitd.h"
#import "SourceKitUID.h"
#import "SourceKitResponse.h"

@implementation SourceKit

- (void)start {
    sourcekitd_initialize();
}

- (void)shutdown {
    sourcekitd_shutdown();
}

- (SourceKitResponse*)sendSynchronousIndexRequestForFile:(SSDFile*)file
                              compilerArgs:(NSArray<NSString*>*)compilerArgs {
    sourcekitd_object_t requestDictionary = sourcekitd_request_dictionary_create(nil, nil, 0);

    sourcekitd_request_dictionary_set_uid(requestDictionary,
                                          [SourceKitUID requestId].uid,
                                          [SourceKitUID indexRequestId].uid);

    sourcekitd_request_dictionary_set_string(requestDictionary,
                                             [SourceKitUID sourceFileId].uid,
                                             [file.path cStringUsingEncoding:NSUTF8StringEncoding]);

    sourcekitd_object_t compilerArgsArgument = sourcekitd_request_array_create(nil, 0);

    [compilerArgs enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char* str = [obj cStringUsingEncoding:NSUTF8StringEncoding];
        sourcekitd_request_array_set_string(compilerArgsArgument, -1, str);
    }];

    sourcekitd_request_dictionary_set_value(requestDictionary,
                                            [SourceKitUID compilerArgsId].uid,
                                            compilerArgsArgument);

//    char* utf8Str = sourcekitd_request_description_copy(requestDictionary);
//    NSString* result = [[NSString alloc] initWithCString:utf8Str encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", result);
//    free(utf8Str);

    sourcekitd_response_t responseObject = sourcekitd_send_request_sync(requestDictionary);
    SourceKitResponse* response = [[SourceKitResponse alloc] initWithSourceKitResponse:responseObject];

    sourcekitd_request_release(compilerArgsArgument);
    sourcekitd_request_release(requestDictionary);

    return response;
}

@end
