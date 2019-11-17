#import "SSDSwiftShieldInteractor.h"
#import "SSDSwiftShieldInteractorDelegate.h"
#import "SSDSchemeInfoProviderProtocol.h"

@interface SSDSwiftShieldInteractor ()
@property (nonatomic) id<SSDSchemeInfoProviderProtocol> schemeInfoProvider;
@property (nonatomic) id<SSDLoggerProtocol> logger;
@property (nonatomic) id<SSDObfuscatorProtocol> obfuscator;
@end

@implementation SSDSwiftShieldInteractor

@synthesize delegate;

- (instancetype)initWithSchemeInfoProvider:(id<SSDSchemeInfoProviderProtocol>)schemeInfoProvider
                                    logger:(id<SSDLoggerProtocol>)logger
                                obfuscator:(id<SSDObfuscatorProtocol>)obfuscator {
    self = [super init];
    if (self) {
        _schemeInfoProvider = schemeInfoProvider;
        _logger = logger;
        _obfuscator = obfuscator;
        self.obfuscator.delegate = self;
    }
    return self;
}

- (void)getModulesFromProject {
    NSError* error;
    NSArray<SSDModule*>* modules = [[self schemeInfoProvider] getModulesFromProject:&error];
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

- (void)obfuscator:(id<SSDObfuscatorProtocol>)obfuscator didFailToObfuscateFile:(nonnull SSDFile *)file withError:(nonnull NSError *)error {
    if (!self.delegate) {
        return;
    }
    [self.delegate interactor:self failedToObfuscateWithError:error];
}

- (BOOL)obfuscator:(id<SSDObfuscatorProtocol>)obfuscator didObfuscateFile:(nonnull SSDFile *)file newContent:(nonnull NSString *)newContent {
    if (!self.delegate) {
        return YES;
    }
    return [self.delegate interactor:self didObfuscate:file newContents:newContent];
}

@end
