#import "SSDSwiftShieldController.h"
#import "SSDFile.h"
#import "SSDModule.h"
#import "SSDSwiftShieldInteractorProtocol.h"
#import "SSDLoggerProtocol.h"

@interface SSDSwiftShieldController ()
@property (nonatomic) id<SSDSwiftShieldInteractorProtocol> interactor;
@property (nonatomic) id<SSDLoggerProtocol> logger;
@end

@implementation SSDSwiftShieldController

- (instancetype)initWithInterator:(id<SSDSwiftShieldInteractorProtocol>)interactor
                           logger:(id<SSDLoggerProtocol>)logger
{
    self = [super init];
    if (self) {
        _interactor = interactor;
        _logger = logger;
        _didFailToRun = NO;
        interactor.delegate = self;
    }
    return self;
}

- (void)run {
    [self.interactor getModulesFromProject];
}

@end

@implementation SSDSwiftShieldController (InteractorDelegate)
- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToRetrieveModulesWithError:(nonnull NSError *)error {
    [self.logger log:error.localizedDescription];
    self.didFailToRun = YES;
}

- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor retrievedModules:(nonnull NSArray<SSDModule *> *)modules {
    [self.logger log:@"Finding references of USRs"];
    [self.interactor obfuscateModules:modules];
}

- (void)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor failedToObfuscateWithError:(nonnull NSError *)error {
    [self.logger log:error.localizedDescription];
    self.didFailToRun = YES;
}

- (BOOL)interactor:(id<SSDSwiftShieldInteractorProtocol>)interactor didObfuscate:(nonnull SSDFile *)file newContents:(nonnull NSString *)newContents {
    NSError* error;
    [self.logger log:[NSString stringWithFormat:@"--- Overwriting %@", file.name]];
    [file writeContents:newContents error:&error];
    if (error) {
        [self.logger log:error.localizedDescription];
        self.didFailToRun = YES;
        return NO;
    }
    return YES;
}

@end
