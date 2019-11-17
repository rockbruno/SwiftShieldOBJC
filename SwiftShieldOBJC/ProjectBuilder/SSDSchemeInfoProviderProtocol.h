#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SSDFile;
@class SSDModule;

/// A protocol representing a type that extracts information from a Xcode project, relevant to a specific scheme.
@protocol SSDSchemeInfoProviderProtocol

/// The project file represented by this protocol.
@property (readonly, nonatomic) SSDFile* projectFile;

/// The scheme from where information should be extracted from.
@property (readonly, nonatomic) NSString* schemeName;

/// Retrieves .pbxproj targets from the relevant Xcode project by building it.
///
/// - Parameters:
///   - error: A pointer to an error that is filled when the operation fails.
- (NSArray<SSDModule*>*)getModulesFromProject:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
