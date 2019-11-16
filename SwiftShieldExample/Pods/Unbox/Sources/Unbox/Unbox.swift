/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

/// Unbox a JSON dictionary into a model `T`. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary) throws -> T {
    return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: dictionary).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz()
}

/// Unbox a JSON dictionary into a model `T` beginning at a certain key. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary, atKey key: String) throws -> T {
    let container: FmbgbhodBzxxZAcgYeuVhkYQlPFeWwaT<T> = try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: dictionary, context: .key(key))
    return container.model
}

/// Unbox a JSON dictionary into a model `T` beginning at a certain key path. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary, atKeyPath keyPath: String) throws -> T {
    let container: FmbgbhodBzxxZAcgYeuVhkYQlPFeWwaT<T> = try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: dictionary, context: .keyPath(keyPath))
    return container.model
}

/// Unbox an array of JSON dictionaries into an array of `T`, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionaries: [UnboxableDictionary], allowInvalidElements: Bool = false) throws -> [T] {
    return try dictionaries.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements, transform: MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk)
}

/// Unbox an array JSON dictionary into an array of model `T` beginning at a certain key, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary, atKey key: String, allowInvalidElements: Bool = false) throws -> [T] {
    let container: OmHJdapfpWxvHXVGbIBZeSkbSDbyubks<T> = try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: dictionary, context: (.key(key), allowInvalidElements))
    return container.models
}

/// Unbox an array JSON dictionary into an array of model `T` beginning at a certain key path, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary, atKeyPath keyPath: String, allowInvalidElements: Bool = false) throws -> [T] {
    let container: OmHJdapfpWxvHXVGbIBZeSkbSDbyubks<T> = try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: dictionary, context: (.keyPath(keyPath), allowInvalidElements))
    return container.models
}

/// Unbox binary data into a model `T`. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(data: Data) throws -> T {
    return try data.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk()
}

/// Unbox binary data into an array of `T`, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(data: Data, atKeyPath keyPath: String? = nil, allowInvalidElements: Bool = false) throws -> [T] {
    if let keyPath = keyPath {
        return try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: JSONSerialization.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(data: data), atKeyPath: keyPath, allowInvalidElements: allowInvalidElements)
    }
    
    return try data.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(allowInvalidElements: allowInvalidElements)
}

/// Unbox a JSON dictionary into a model `T` using a required contextual object. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(dictionary: UnboxableDictionary, context: T.UnboxContext) throws -> T {
    return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: dictionary).fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz(context: context)
}

/// Unbox an array of JSON dictionaries into an array of `T` using a required contextual object, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(dictionaries: [UnboxableDictionary], context: T.UnboxContext, allowInvalidElements: Bool = false) throws -> [T] {
    return try dictionaries.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements, transform: {
        try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: $0, context: context)
    })
}

/// Unbox binary data into a model `T` using a required contextual object. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(data: Data, context: T.UnboxContext) throws -> T {
    return try data.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(context: context)
}

/// Unbox binary data into an array of `T` using a required contextual object, optionally allowing invalid elements. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(data: Data, context: T.UnboxContext, allowInvalidElements: Bool = false) throws -> [T] {
    return try data.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(context: context, allowInvalidElements: allowInvalidElements)
}

/// Unbox binary data into a dictionary of type `[String: T]`. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(data: Data) throws -> [String: T] {
    let dictionary : [String: [String: Any]] = try JSONSerialization.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(data: data)
    return try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: dictionary)
}

/// Unbox `UnboxableDictionary` into a dictionary of type `[String: T]` where `T` is `Unboxable`. Throws `UnboxError`.
public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(dictionary: UnboxableDictionary) throws -> [String: T] {
    var mappedDictionary = [String: T]()
    try dictionary.forEach { key, value in
        guard let innerDictionary = value as? UnboxableDictionary else {
            throw UnboxError.invalidData
        }
        let data : T = try MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(dictionary: innerDictionary)
        mappedDictionary[key] = data
    }
    return mappedDictionary
}
