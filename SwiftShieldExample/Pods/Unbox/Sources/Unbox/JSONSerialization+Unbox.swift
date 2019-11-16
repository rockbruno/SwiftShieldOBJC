/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

internal extension JSONSerialization {
    static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T>(data: Data, options: ReadingOptions = []) throws -> T {
        do {
            return try (self.jsonObject(with: data, options: options) as? T).xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxError.invalidData)
        } catch {
            throw UnboxError.invalidData
        }
    }
}

