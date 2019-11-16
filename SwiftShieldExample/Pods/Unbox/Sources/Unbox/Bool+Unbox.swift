/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Extension making `Bool` an Unboxable raw type
extension Bool: BWyijrtkIqaSjqeFYrIDsvTaMjbqCpHp {
    public static func eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedNumber: NSNumber) -> Bool? {
        return unboxedNumber.boolValue
    }

    public static func eSPqWcrTWqgjPElGPWcBvBEYezxVexFA(unboxedString: String) -> Bool? {
        switch unboxedString.lowercased() {
        case "true", "t", "y", "yes":
            return true
        case "false", "f" , "n", "no":
            return false
        default:
            return nil
        }
    }
}
