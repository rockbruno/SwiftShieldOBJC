#import <Foundation/Foundation.h>
#import "SSDSwiftShieldController.h"
#import "SSDNSLogLogger.h"
#import "SSDFile.h"
#import "SSDXcodeOutputParser.h"
#import "SSDXcodeSchemeInformationProvider.h"
#import "SSDSourceKit.h"
#import "SSDSourceKitObfuscator.h"
#import "SSDSourceKitObfuscatorDataStore.h"
#import "SSDSwiftShieldInteractor.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* projectFileString = @"/Users/bruno.rocha/Desktop/PersonalCodes/SwiftShieldOBJC/SwiftShieldExample/SwiftShieldExample.xcworkspace";//[[NSUserDefaults standardUserDefaults] stringForKey:@"workspace"];
        NSString* schemeName = @"SwiftShieldExample";//[[NSUserDefaults standardUserDefaults] stringForKey:@"scheme"];

        SSDFile* file = [[SSDFile alloc] initWithPath:projectFileString];

        SSDNSLogLogger* logger = [SSDNSLogLogger new];
        SSDXcodeOutputParser* xcodeParser = [[SSDXcodeOutputParser alloc] initWithLogger:logger];
        SSDXcodeSchemeInformationProvider* schemeInfo = [[SSDXcodeSchemeInformationProvider alloc]
                                                         initWithProjectFile:file
                                                                  schemeName:schemeName
                                                           buildOutputParser:xcodeParser
                                                                      logger:logger];

        SSDSourceKit* sourceKit = [SSDSourceKit new];
        [sourceKit start];

        SSDSourceKitObfuscator* obfuscator = [[SSDSourceKitObfuscator alloc] initWithSourceKit:sourceKit
                                                                                        logger:logger
                                                                                     dataStore:[SSDSourceKitObfuscatorDataStore new]];

        SSDSwiftShieldInteractor* interactor = [[SSDSwiftShieldInteractor alloc] initWithSchemeInformationProvider:schemeInfo logger:logger obfuscator:obfuscator];

        SSDSwiftShieldController* runner = [[SSDSwiftShieldController alloc] initWithInterator:interactor logger:logger];

        [runner run];

        [sourceKit shutdown];

        if (runner.didFailToRun) {
            return 1;
        } else {
            return 0;
        }
    }
}
