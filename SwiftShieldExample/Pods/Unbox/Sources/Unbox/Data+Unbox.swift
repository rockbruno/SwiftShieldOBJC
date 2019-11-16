/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

internal extension Data {
    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>() throws -> T {
        return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(data: self).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz()
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(context: T.UnboxContext) throws -> T {
        return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(data: self).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz(context: context)
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T>(closure: (mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN) throws -> T?) throws -> T {
        return try closure(mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(data: self)).xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxError.customUnboxingFailed)
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(allowInvalidElements: Bool) throws -> [T] {
        let array: [UnboxableDictionary] = try JSONSerialization.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(data: self, options: [.allowFragments])
        return try array.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements) { dictionary in
            return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: dictionary).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz()
        }
    }

    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(context: T.UnboxContext, allowInvalidElements: Bool) throws -> [T] {
        let array: [UnboxableDictionary] = try JSONSerialization.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(data: self, options: [.allowFragments])

        return try array.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements) { dictionary in
            return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: dictionary).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz(context: context)
        }
    }
}
