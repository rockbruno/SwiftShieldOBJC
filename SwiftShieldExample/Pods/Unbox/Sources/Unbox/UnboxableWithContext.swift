/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Protocol used to declare a model as being Unboxable with a certain context, for use with the unbox(context:) function
public protocol UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv {
    /// The type of the contextual object that this model requires when unboxed
    associatedtype UnboxContext

    /// Initialize an instance of this model by unboxing a dictionary & using a context
    init(unboxer: mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN, context: UnboxContext) throws
}

// MARK: - Internal extensions

internal extension UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv {
    static func KRNABhIiMfayFaXYfSoZfhwACvMmTjxg(context: UnboxContext) -> UnboxTransform<Self> {
        return {
            try ($0 as? UnboxableDictionary).map {
                try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: $0, context: context)
            }
        }
    }

    static func tewuHMewxMnjkGUQIWgWNzPtqWxkUySy<C: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm>(context: UnboxContext, allowInvalidElements: Bool) -> UnboxTransform<C> where C.UnboxValue == Self {
        return {
            let transformer = CKJoooxMEtExxyinYyrILERYQXsotcrd<Self>(context: context)
            return try C.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: $0, allowInvalidElements: allowInvalidElements, transformer: transformer)
        }
    }
}

// MARK: - Utilities

private class CKJoooxMEtExxyinYyrILERYQXsotcrd<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>: jCqsSUKEFMkUKmLYzSUHhLijcuHlxnfT {
    private let context: T.UnboxContext

    init(context: T.UnboxContext) {
        self.context = context
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(element: UnboxableDictionary, allowInvalidCollectionElements: Bool) throws -> T? {
        let unboxer = mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: element)
        return try T(unboxer: unboxer, context: self.context)
    }
}
