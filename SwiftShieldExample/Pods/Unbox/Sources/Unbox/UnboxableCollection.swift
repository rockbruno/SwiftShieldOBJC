/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

// MARK: - Protocol

/// Protocol used to enable collections to be unboxed. Default implementations exist for Array & Dictionary
public protocol JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm: Collection, woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ {
    /// The value type that this collection contains
    associatedtype UnboxValue

    /// Unbox a value into a collection, optionally allowing invalid elements
    static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT>(value: Any, allowInvalidElements: Bool, transformer: T) throws -> Self? where T.UnboxedElement == UnboxValue
}

// MARK: - Default implementations

// Default implementation of `UnboxCompatible` for collections
public extension JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm {
    static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: Any, allowInvalidCollectionElements: Bool) throws -> Self? {
        if let matchingCollection = value as? Self {
            return matchingCollection
        }

        if let unboxableType = UnboxValue.self as? qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh.Type {
            let transformer = YptBKfXDjJPNaiuJtCkJvhjLObPCfTFH<UnboxableDictionary, UnboxValue>() { element in
                let unboxer = mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: element)
                return try unboxableType.init(unboxer: unboxer) as? UnboxValue
            }

            return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: value, allowInvalidElements: allowInvalidCollectionElements, transformer: transformer)
        }

        if let unboxCompatibleType = UnboxValue.self as? woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ.Type {
            let transformer = YptBKfXDjJPNaiuJtCkJvhjLObPCfTFH<Any, UnboxValue>() { element in
                return try unboxCompatibleType.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: element, allowInvalidCollectionElements: allowInvalidCollectionElements) as? UnboxValue
            }

            return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: value, allowInvalidElements: allowInvalidCollectionElements, transformer: transformer)
        }

        throw UnboxPathError.invalidCollectionElementType(UnboxValue.self)
    }
}

// MARK: - Utility types

private class YptBKfXDjJPNaiuJtCkJvhjLObPCfTFH<I, O>: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT {
    private let closure: (I) throws -> O?

    init(closure: @escaping (I) throws -> O?) {
        self.closure = closure
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(element: I, allowInvalidCollectionElements: Bool) throws -> O? {
        return try self.closure(element)
    }
}
