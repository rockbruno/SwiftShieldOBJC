#import <Foundation/Foundation.h>
#import "SSDSwiftShieldConfigurator.h"
#import "SSDSwiftShieldController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* projectFileString = [[NSUserDefaults standardUserDefaults] stringForKey:@"workspace"];
        NSString* schemeName = [[NSUserDefaults standardUserDefaults] stringForKey:@"scheme"];

        SSDSwiftShieldController* runner = [SSDSwiftShieldConfigurator resolveFromProject:projectFileString
                                                                                   scheme:schemeName];

        [runner run];

        if (runner.didFailToRun) {
            return 1;
        } else {
            return 0;
        }
    }
}
