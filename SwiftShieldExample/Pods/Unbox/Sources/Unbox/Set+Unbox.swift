/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Extension making `Set` an unboxable collection
extension Set: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm {
    public typealias UnboxValue = Element

    public static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT>(value: Any, allowInvalidElements: Bool, transformer: T) throws -> Set? where T.UnboxedElement == UnboxValue {
        guard let array = try [UnboxValue].MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: value, allowInvalidElements: allowInvalidElements, transformer: transformer) else {
            return nil
        }

        return Set(array)
    }
}
