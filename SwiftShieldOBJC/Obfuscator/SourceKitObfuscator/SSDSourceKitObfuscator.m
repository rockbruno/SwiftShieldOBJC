#import "SSDSourceKitObfuscator.h"
#import "SSDObfuscatorProtocol.h"
#import "SSDModule.h"
#import "SSDSourceKit.h"
#import "SSDSourceKitResponse.h"
#import "SSDSourceKitUID.h"
#import "SSDSourceKitObfuscatorDataStore.h"
#import "SSDIndexedFile.h"
#import "SSDReference.h"

@interface SSDSourceKitObfuscator ()
@property (nonatomic) SSDSourceKit* sourceKit;
@property (nonatomic) id<SSDLoggerProtocol> logger;
@property (nonatomic) SSDSourceKitObfuscatorDataStore* dataStore;
@end

@implementation SSDSourceKitObfuscator

@synthesize delegate;

- (instancetype)initWithSourceKit:(SSDSourceKit*)sourceKit
                           logger:(id<SSDLoggerProtocol>)logger
                        dataStore:(SSDSourceKitObfuscatorDataStore*)dataStore {
    self = [super init];
    if (self) {
        _sourceKit = sourceKit;
        _logger = logger;
        _dataStore = dataStore;
        [self.sourceKit start];
    }
    return self;
}

- (void)registerModuleForObfuscation:(SSDModule*)module {
    [module.sourceFiles enumerateObjectsUsingBlock:^(SSDFile * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* log = [NSString stringWithFormat:@"--- Indexing: %@", file.name];
        [self.logger log:log];
        SSDSourceKitResponse* response = [self.sourceKit sendSynchronousIndexRequestForFile:file
                                                                            compilerArgs:module.compilerArguments];
        [response recurseOverUid:[SSDSourceKitUID entitiesId] block:^(SSDSourceKitResponseVariant * _Nonnull variant) {
            [self processDeclarationEntity:variant ofResponse:response ofFile:file];
        }];

        SSDIndexedFile* indexedFile = [[SSDIndexedFile alloc] initWithFile:file andResponse:response];
        [self.dataStore.indexedFiles addObject:indexedFile];
    }];
}

- (void)processDeclarationEntity:(SSDSourceKitResponseVariant*)variant
                      ofResponse:(SSDSourceKitResponse*)response
                          ofFile:(SSDFile*)file {
    SSDSourceKitResponseDictionary* dict = [variant dictionary];
    SSDSourceKitUID* entityKind = [dict getUid: [SSDSourceKitUID kindId]];
    SSDSourceKitDeclarationType declType = [entityKind declarationType];
    if (declType == SSDSourceKitDeclarationTypeUnsupported) {
        return;
    }
    NSString* rawName = [dict getString:[SSDSourceKitUID nameId]];
    NSString* usr = [dict getString:[SSDSourceKitUID usrId]];
    if (!rawName || !usr) {
        return;
    }

    NSString* name = [self removeParameterInformationFromString:rawName];

    [self.logger log:[NSString stringWithFormat:@"Found declaration of %@ (USR: %@)", name, usr]];
    [self.dataStore.processedUsrs addObject:usr];

    if (![dict getString:[SSDSourceKitUID receiverId]]) {
        self.dataStore.usrRelationDictionary[usr] = variant;
    }
}

- (NSString*)removeParameterInformationFromString:(NSString*)string {
    return [[string componentsSeparatedByString:@"("] firstObject];
}

- (void)obfuscate {
    [self.dataStore.indexedFiles enumerateObjectsUsingBlock:^(SSDIndexedFile * _Nonnull obj,
                                                              NSUInteger idx,
                                                              BOOL * _Nonnull stop)
    {
        [self.logger log: [NSString stringWithFormat:@"--- Obfuscating %@", obj.file.name]];
        NSMutableArray<SSDReference*>* referenceArray = [NSMutableArray new];
        [obj.response recurseOverUid:[SSDSourceKitUID entitiesId] block:^(SSDSourceKitResponseVariant * _Nonnull variant) {
            SSDSourceKitResponseDictionary* dict = [variant dictionary];
            SSDSourceKitUID* kindUid = [dict getUid:[SSDSourceKitUID kindId]];
            SSDSourceKitDeclarationType referenceType = [kindUid declarationTypeForReferenceKind];
            if (referenceType == SSDSourceKitDeclarationTypeUnsupported) {
                return;
            }
            NSString* usr = [dict getString:[SSDSourceKitUID usrId]];
            NSString* rawName = [dict getString:[SSDSourceKitUID nameId]];
            if (!usr || !rawName) {
                return;
            }

            if ([self.dataStore.processedUsrs containsObject:usr] == NO) {
                return;
            }

            if ([self isVariantReferencingClosedSourceFrameworks:variant ofType:referenceType]) {
                return;
            }

            NSInteger line = [dict getInt:[SSDSourceKitUID lineId]];
            NSInteger column = [dict getInt:[SSDSourceKitUID colId]];
            NSString* name = [self removeParameterInformationFromString:rawName];
            NSString* obfuscatedName = [self obfuscatedStringForString:name];

            NSString* format = @"Found reference of %@ (USR: %@) at %@ (%ld:%ld) -> now %@";
            [self.logger log:[NSString stringWithFormat:format, name, usr, obj.file.name, (long)line, (long)column, obfuscatedName]];

            SSDReference* reference = [[SSDReference alloc] initWithName:name line:line column:column];
            [referenceArray addObject:reference];
        }];

        NSError* error;
        NSString* originalContents = [obj.file read:&error];
        NSString* obfuscatedContents = [self getObfuscatedFile:originalContents
                                                withReferences:referenceArray];
        if (!error) {
            *stop = ![self.delegate obfuscator:self didObfuscateFile:obj.file newContent:obfuscatedContents];
        } else {
            [self.delegate obfuscator:self didFailToObfuscateFile:obj.file withError:error];
            *stop = YES;
        }
    }];
}

- (BOOL)isVariantReferencingClosedSourceFrameworks:(SSDSourceKitResponseVariant*)variant
                                            ofType:(SSDSourceKitDeclarationType)type {
    if (type != SSDSourceKitDeclarationTypeMethod && type != SSDSourceKitDeclarationTypeProperty) {
        return NO;
    }
    NSString* usr = [[variant dictionary] getString:[SSDSourceKitUID usrId]];
    if (!usr) {
        return NO;
    }
    SSDSourceKitResponseVariant* relatedVariant = self.dataStore.usrRelationDictionary[usr];
    if (relatedVariant && [relatedVariant isEqualTo:variant] == NO) {
        return [self isVariantReferencingClosedSourceFrameworks:relatedVariant
                                                         ofType:type];
    }
    BOOL __block isReference = NO;
    [variant recurseOverUid:[SSDSourceKitUID relatedId] block:^(SSDSourceKitResponseVariant * _Nonnull variant) {
        if (isReference) {
            return;
        }
        NSString* usr = [[variant dictionary] getString:[SSDSourceKitUID usrId]];
        if (!usr) {
            return;
        }
        if ([self.dataStore.processedUsrs containsObject:usr] == NO) {
            isReference = YES;
        } else {
            SSDSourceKitResponseVariant* relatedVariant = self.dataStore.usrRelationDictionary[usr];
            if (relatedVariant) {
                isReference = [self isVariantReferencingClosedSourceFrameworks:relatedVariant
                                                                        ofType:type];
            }
        }
    }];
    return isReference;
}

- (NSString*)getObfuscatedFile:(NSString*)fileString
                withReferences:(NSArray<SSDReference*>*)references {

    NSArray<SSDReference*>* sortedReferences = [references sortedArrayUsingSelector:@selector(compare:)];

    SSDReference* previousReference;

    int currentReferenceIndex = 0;
    int line = 1;
    int column = 1;
    int currentCharIndex = 0;

    NSMutableArray* charArray = [NSMutableArray new];
    for (int i=0; i<fileString.length; i++) {
        unichar character = [fileString characterAtIndex:i];
        NSString* string = [NSString stringWithFormat: @"%C", character];
        [charArray addObject:string];
    }

    while (currentCharIndex < fileString.length && currentReferenceIndex < sortedReferences.count) {
        SSDReference* reference = sortedReferences[currentReferenceIndex];
        if (previousReference && reference.line == previousReference.line
                              && reference.column == previousReference.column)
        {
            // Avoid duplicates.
            currentReferenceIndex += 1;
        }
        if (line == reference.line && column == reference.column) {
            previousReference = reference;
            NSString* originalName = reference.name;
            NSString* obfuscatedName = [self obfuscatedStringForString:originalName];
            BOOL wasInternalKeyword = [charArray[currentCharIndex] isEqualTo:@"`"];
            for (int i = 1; i < originalName.length + (wasInternalKeyword ? 2 : 0); i++) {
                charArray[currentCharIndex + i] = @"";
            }
            charArray[currentCharIndex] = obfuscatedName;
            currentReferenceIndex += 1;
            currentCharIndex += originalName.length;
            column += originalName.length;
            if (wasInternalKeyword) {
                charArray[currentCharIndex] = @"";
            }
        } else if ([charArray[currentCharIndex] isEqualTo:@"\n"]) {
            line += 1;
            column = 1;
            currentCharIndex += 1;
        } else {
            column += 1;
            currentCharIndex += 1;
        }
    }
    NSMutableString* finalString = [NSMutableString new];
    [charArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [finalString appendString:obj];
    }];
    return finalString;
}

- (NSString*)obfuscatedStringForString:(NSString*)string {
    NSString* cachedResult = self.dataStore.obfuscatedNames[string];
    if (cachedResult) {
        return cachedResult;
    } else {
        NSInteger obfuscatedNameSize = 32;
        NSString* letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        NSString* numbers = @"0123456789";
        NSString* lettersAndNumbers = [letters stringByAppendingString:numbers];
        NSMutableString* newString = [NSMutableString new];
        for (int i = 0; i < obfuscatedNameSize; i++) {
            NSString* pool = i == 0 ? letters : lettersAndNumbers;
            uint32_t poolSize = (uint32_t)[pool length];
            NSInteger index = arc4random_uniform(poolSize);
            NSString* base = i == 0 ? letters : lettersAndNumbers;
            unichar character = [base characterAtIndex:index];
            [newString appendString:[NSString stringWithFormat: @"%C", character]];
        }
        self.dataStore.obfuscatedNames[string] = newString;
        return newString;
    }
}

- (void)dealloc
{
    [self.sourceKit shutdown];
}

@end
