#import "SSDSwiftShieldInteractor.h"
#import "SSDXcodeSchemeInformationProvider.h"

@interface SSDSwiftShieldInteractor (ObfuscatorDelegate) <SSDObfuscatorDelegate>
@end

@interface SSDSwiftShieldInteractor ()
@property (nonatomic) SSDXcodeSchemeInformationProvider* schemeInformationProvider;
@property (nonatomic) SSDLogger logger;
@property (nonatomic) SSDObfuscatorProtocol obfuscator;
@end

@implementation SSDSwiftShieldInteractor

- (instancetype)initWithSchemeInformationProvider:(SSDXcodeSchemeInformationProvider*)schemeInformationProvider
                                           logger:(SSDLogger)logger
                                       obfuscator:(SSDObfuscatorProtocol)obfuscator {
    self = [super init];
    if (self) {
        _schemeInformationProvider = schemeInformationProvider;
        _logger = logger;
        _obfuscator = obfuscator;
        self.obfuscator.delegate = self;
    }
    return self;
}

- (void)getModulesFromProject {
    NSError* error;
    NSArray<SSDModule*>* modules = [[self schemeInformationProvider] getModulesFromProject:&error];
    if (!self.delegate) {
        return;
    }
    if (error) {
        [self.delegate interactor:self failedToRetrieveModulesWithError:error];
    } else {
        [self.delegate interactor:self retrievedModules:modules];
    }
}

- (void)obfuscateModules:(NSArray<SSDModule*>*)modules {
    [modules enumerateObjectsUsingBlock:^(SSDModule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.obfuscator registerModuleForObfuscation:obj];
    }];
    [self.obfuscator obfuscate];
}
@end

@implementation SSDSwiftShieldInteractor (ObfuscatorDelegate)

- (void)obfuscator:(nonnull SSDObfuscatorProtocol)obfuscator didFailToObfuscateFile:(nonnull SSDFile *)file withError:(nonnull NSError *)error {
    if (!self.delegate) {
        return;
    }
    [self.delegate interactor:self failedToObfuscateWithError:error];
}

- (BOOL)obfuscator:(nonnull SSDObfuscatorProtocol)obfuscator didObfuscateFile:(nonnull SSDFile *)file newContent:(nonnull NSString *)newContent {
    if (!self.delegate) {
        return YES;
    }
    return [self.delegate interactor:self didObfuscate:file newContents:newContent];
}

@end
