#import "SSDSwiftShieldController.h"
#import "SSDFile.h"
#import "SSDModule.h"
#import "SSDSwiftShieldInteractor.h"
#import "SSDLogger.h"

@interface SSDSwiftShieldController (InteractorDelegate) <SSDSwiftShieldInteractorDelegate>
@end

@interface SSDSwiftShieldController ()
@property (nonatomic) SSDSwiftShieldInteractor* interactor;
@property (nonatomic) SSDLogger logger;
@end

@implementation SSDSwiftShieldController

- (instancetype)initWithInterator:(SSDSwiftShieldInteractor*)interactor
                           logger:(SSDLogger)logger
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
- (void)interactor:(nonnull SSDSwiftShieldInteractor *)interactor failedToRetrieveModulesWithError:(nonnull NSError *)error {
    [self.logger log:error.localizedDescription];
    self.didFailToRun = YES;
}

- (void)interactor:(nonnull SSDSwiftShieldInteractor *)interactor retrievedModules:(nonnull NSArray<SSDModule *> *)modules {
    [self.logger log:@"Finding references of USRs"];
    [self.interactor obfuscateModules:modules];
}

- (void)interactor:(nonnull SSDSwiftShieldInteractor *)interactor failedToObfuscateWithError:(nonnull NSError *)error {
    [self.logger log:error.localizedDescription];
    self.didFailToRun = YES;
}

- (BOOL)interactor:(nonnull SSDSwiftShieldInteractor *)interactor didObfuscate:(nonnull SSDFile *)file newContents:(nonnull NSString *)newContents {
    NSError* error;
    [self.logger log:[NSString stringWithFormat:@"Overwritting %@", file.name]];
//    [file writeContents:newContents error:&error];
    if (error) {
        [self.logger log:error.localizedDescription];
        self.didFailToRun = YES;
        return NO;
    }
    return YES;
}

@end
