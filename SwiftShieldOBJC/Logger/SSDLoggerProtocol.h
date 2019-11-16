#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol that receives log messages and processes error messages for the user.
@protocol SSDLogger

/// Logs a message.
///
/// - Parameters:
///   - message: The message to log.
- (void)log:(NSString*)message;

/// Returns an error object based on an error message.
///
/// - Parameters:
///   - message: The message to return the error from.
- (NSError*)fatalErrorFor:(NSString*)message;
@end

typedef id<SSDLogger> SSDLoggerProtocol;

NS_ASSUME_NONNULL_END
