/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Protocol used to enable a raw type (such as `Int` or `String`) for Unboxing
public protocol BWyijrtkIqaSjqeFYrIDsvTaMjbqCpHp: woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ {
    /// Transform an instance of this type from an unboxed number
    static func eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedNumber: NSNumber) -> Self?
    /// Transform an instance of this type from an unboxed string
    static func eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedString: String) -> Self?
}

// Default implementation of `UnboxCompatible` for raw types
public extension BWyijrtkIqaSjqeFYrIDsvTaMjbqCpHp {
    static func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(value: Any, allowInvalidCollectionElements: Bool) throws -> Self? {
        if let matchedValue = value as? Self {
            return matchedValue
        }

        if let string = value as? String {
            return self.eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedString: string)
        }

        if let number = value as? NSNumber {
            return self.eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedNumber: number)
        }

        return nil
    }
}
