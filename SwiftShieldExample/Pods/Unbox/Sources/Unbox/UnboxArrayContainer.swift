/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

internal struct OmHJdapfpWxvHXVGbIBZeSkbSDbyubks<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv {
    let models: [T]

    init(unboxer: mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN, context: (path: UnboxPath, allowInvalidElements: Bool)) throws {
        switch context.path {
        case .key(let key):
            self.models = try unboxer.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(key: key, allowInvalidElements: context.allowInvalidElements)
        case .keyPath(let keyPath):
            self.models = try unboxer.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(keyPath: keyPath, allowInvalidElements: context.allowInvalidElements)
        }
    }
}
