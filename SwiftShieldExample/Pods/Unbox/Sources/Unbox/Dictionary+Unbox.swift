/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Extension making `Dictionary` an unboxable collection
extension Dictionary: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm {
    public typealias UnboxValue = Value

    public static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT>(value: Any, allowInvalidElements: Bool, transformer: T) throws -> Dictionary? where T.UnboxedElement == UnboxValue {
        guard let dictionary = value as? [String : T.UnboxRawElement] else {
            return nil
        }

        let keyTransform = try self.tnWFUWpYfOgrFbJofIvrtlTLhKXFcOyY()

        return try dictionary.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements) { key, value in
            guard let unboxedKey = keyTransform(key) else {
                throw UnboxPathError.invalidDictionaryKey(key)
            }

            guard let unboxedValue = try transformer.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(element: value, allowInvalidCollectionElements: allowInvalidElements) else {
                throw UnboxPathError.invalidDictionaryValue(value, key)
            }

            return (unboxedKey, unboxedValue)
        }
    }

    private static func tnWFUWpYfOgrFbJofIvrtlTLhKXFcOyY() throws -> (String) -> Key? {
        if Key.self is String.Type {
            return { $0 as? Key }
        }

        if let keyType = Key.self as? ownoLKrOvJsomJFIwXtNsjkUoFcmmTxs.Type {
            return { keyType.eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedKey: $0) as? Key }
        }

        throw UnboxPathError.invalidDictionaryKeyType(Key.self)
    }
}

/// Extension making `Dictionary` an unbox path node
extension Dictionary: DknCAsolhbYkFfcjZuotoFXSMASBLZEa {
    func SmHmnTKFpOULoSeBYzhjAbOudNIkDCGQ(forKey key: String) -> Any? {
        return self[key as! Key]
    }
}

// MARK: - Utilities

private extension Dictionary {
    func iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc<K, V>(allowInvalidElements: Bool, transform: (Key, Value) throws -> (K, V)?) throws -> [K : V]? {
        var transformedDictionary = [K : V]()

        for (key, value) in self {
            do {
                guard let transformed = try transform(key, value) else {
                    if allowInvalidElements {
                        continue
                    }

                    return nil
                }

                transformedDictionary[transformed.0] = transformed.1
            } catch {
                if !allowInvalidElements {
                    throw error
                }
            }
        }

        return transformedDictionary
    }
}
