/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Protocol used to enable any type as being unboxable, by transforming a raw value
public protocol sWjmIdIyZtdnOpGYUsrUcNKAjDVyTesJ: woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ {
    /// The type of raw value that this type can be transformed from. Must be a valid JSON type.
    associatedtype UnboxRawValue

    /// Attempt to transform a raw unboxed value into an instance of this type
    static func eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedValue: UnboxRawValue) -> Self?
}

/// Default implementation of `UnboxCompatible` for transformable types
public extension sWjmIdIyZtdnOpGYUsrUcNKAjDVyTesJ {
    static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: Any, allowInvalidCollectionElements: Bool) throws -> Self? {
        return (value as? UnboxRawValue).iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(self.eSPqWcrTWqgjPElGPWcBvBEYezxVexFA)
    }
}
