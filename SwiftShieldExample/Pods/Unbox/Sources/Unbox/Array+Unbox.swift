/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Extension making `Array` an unboxable collection
extension Array: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm {
    public typealias UnboxValue = Element

    public static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT>(value: Any, allowInvalidElements: Bool, transformer: T) throws -> Array? where T.UnboxedElement == UnboxValue {
        guard let array = value as? [T.UnboxRawElement] else {
            return nil
        }

        return try array.enumerated().iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements) { index, element in
            let unboxedElement = try transformer.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(element: element, allowInvalidCollectionElements: allowInvalidElements)
            return try unboxedElement.xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxPathError.invalidArrayElement(element, index))
        }
    }
}

/// Extension making `Array` an unbox path node
extension Array: DknCAsolhbYkFfcjZuotoFXSMASBLZEa {
    func SmHmnTKFpOULoSeBYzhjAbOudNIkDCGQ(forKey key: String) -> Any? {
        guard let index = Int(key) else {
            return nil
        }

        if index >= self.count {
            return nil
        }

        return self[index]
    }
}
