/**
 *  Unbox
 *  Copyright (c) 2015-2017 John Sundell
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

// MARK: - Public

/**
 *  Class used to Unbox (decode) values from a dictionary
 *
 *  For each supported type, simply call `unbox(key: string)` (where `string` is a key in the dictionary that is being unboxed)
 *  - and the correct type will be returned. If a required (non-optional) value couldn't be unboxed `UnboxError` will be thrown.
 */
public final class mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN {
    /// The underlying JSON dictionary that is being unboxed
    public let dictionary: UnboxableDictionary

    // MARK: - Initializer

    /// Initialize an instance with a dictionary that can then be decoded using the `unbox()` methods.
    public init(dictionary: UnboxableDictionary) {
        self.dictionary = dictionary
    }

    /// Initialize an instance with binary data than can then be decoded using the `unbox()` methods. Throws `UnboxError` for invalid data.
    public init(data: Data) throws {
        self.dictionary = try JSONSerialization.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(data: data)
    }

    // MARK: - Custom unboxing API

    /// Perform custom unboxing using an Unboxer (created from a dictionary) passed to a closure, or throw an UnboxError
    public static func UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF<T>(dictionary: UnboxableDictionary, closure: (mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN) throws -> T?) throws -> T {
        return try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: dictionary).UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF(closure: closure)
    }

    /// Perform custom unboxing on an array of dictionaries, executing a closure with a new Unboxer for each one, or throw an UnboxError
    public static func UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF<T>(array: [UnboxableDictionary], allowInvalidElements: Bool = false, closure: (mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN) throws -> T?) throws -> [T] {
        return try array.iCdjnWpHCvqSUEegHZPZfrlrWHFxOukc(allowInvalidElements: allowInvalidElements) {
            try mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN(dictionary: $0).UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF(closure: closure)
        }
    }

    /// Perform custom unboxing using an Unboxer (created from binary data) passed to a closure, or throw an UnboxError
    public static func UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF<T>(data: Data, closure: @escaping (mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN) throws -> T?) throws -> T {
        return try data.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(closure: closure)
    }

    // MARK: - Unboxing required values (by key)

    /// Unbox a required value by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ>(key: String) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: T.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk)
    }

    /// Unbox a required collection by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm>(key: String, allowInvalidElements: Bool) throws -> T {
        let transform = T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg(allowInvalidElements: allowInvalidElements)
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: transform)
    }

    /// Unbox a required Unboxable type by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(key: String) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg())
    }

    /// Unbox a required UnboxableWithContext type by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(key: String, context: T.UnboxContext) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg(context: context))
    }

    /// Unbox a required collection of UnboxableWithContext values by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<C: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm, V: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(key: String, context: V.UnboxContext, allowInvalidElements: Bool = false) throws -> C where C.UnboxValue == V {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: V.tewuHMewxMnjkGUQIWgWNzPtqWxkUySy(context: context, allowInvalidElements: allowInvalidElements))
    }

    /// Unbox a required value using a formatter by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<F: YisqpKOLZViXrAtfeslWQESQvYGHsIwJ>(key: String, formatter: F) throws -> F.UnboxFormattedType {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: formatter.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg())
    }

    /// Unbox a required collection of values using a formatter by key
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<C: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm, F: YisqpKOLZViXrAtfeslWQESQvYGHsIwJ>(key: String, formatter: F, allowInvalidElements: Bool = false) throws -> C where C.UnboxValue == F.UnboxFormattedType {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .key(key), transform: formatter.tewuHMewxMnjkGUQIWgWNzPtqWxkUySy(allowInvalidElements: allowInvalidElements))
    }

    // MARK: - Unboxing required values (by key path)

    /// Unbox a required value by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ>(keyPath: String) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: T.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk)
    }

    /// Unbox a required collection by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: woSDOVYGJBPtGvxBEspjFMeLQMMMjYhJ>(keyPath: String, allowInvalidElements: Bool) throws -> T where T: Collection {
        let transform = T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg(allowInvalidElements: allowInvalidElements)
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: transform)
    }

    /// Unbox a required Unboxable by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>(keyPath: String) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg())
    }

    /// Unbox a required UnboxableWithContext type by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(keyPath: String, context: T.UnboxContext) throws -> T {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: T.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg(context: context))
    }

    /// Unbox a required collection of UnboxableWithContext values by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<C: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm, V: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(keyPath: String, context: V.UnboxContext, allowInvalidElements: Bool = false) throws -> C where C.UnboxValue == V {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: V.tewuHMewxMnjkGUQIWgWNzPtqWxkUySy(context: context, allowInvalidElements: allowInvalidElements))
    }

    /// Unbox a required value using a formatter by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<F: YisqpKOLZViXrAtfeslWQESQvYGHsIwJ>(keyPath: String, formatter: F) throws -> F.UnboxFormattedType {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: formatter.KRNABhIiMfayFaXYfSoZfhwACvMmTjxg())
    }

    /// Unbox a required collection of values using a formatter by key path
    public func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<C: JgDJCzljJGSMkBuvCqAyoigRhtVaXMxm, F: YisqpKOLZViXrAtfeslWQESQvYGHsIwJ>(keyPath: String, formatter: F, allowInvalidElements: Bool = false) throws -> C where C.UnboxValue == F.UnboxFormattedType {
        return try self.MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk(path: .keyPath(keyPath), transform: formatter.tewuHMewxMnjkGUQIWgWNzPtqWxkUySy(allowInvalidElements: allowInvalidElements))
    }
}

// MARK: - Internal

internal extension mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN {
    func fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz<T: qtQjEjNZZSWUSqjniuWJRhYkbYcptEjh>() throws -> T {
        return try T(unboxer: self)
    }

    func fumKTFOPLbwEFjqqErxMXBVhoGJaUgJz<T: UoFMpKBBOfIFWFxnbTAlXpHzyJdRDZHv>(context: T.UnboxContext) throws -> T {
        return try T(unboxer: self, context: context)
    }
}

// MARK: - Private

private extension mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN {
    func MsZnnKcxLfDXfoybNFYgGpeGaDCXEprk<R>(path: UnboxPath, transform: UnboxTransform<R>) throws -> R {
        do {
            switch path {
            case .key(let key):
                let value = try self.dictionary[key].xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxPathError.missingKey(key))
                return try transform(value).xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxPathError.invalidValue(value, key))
            case .keyPath(let keyPath):
                var node: DknCAsolhbYkFfcjZuotoFXSMASBLZEa = self.dictionary
                let components = keyPath.components(separatedBy: ".")

                for (index, key) in components.enumerated() {
                    guard let nextValue = node.SmHmnTKFpOULoSeBYzhjAbOudNIkDCGQ(forKey: key) else {
                        throw UnboxPathError.missingKey(key)
                    }

                    if index == components.index(before: components.endIndex) {
                        return try transform(nextValue).xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxPathError.invalidValue(nextValue, key))
                    }

                    guard let nextNode = nextValue as? DknCAsolhbYkFfcjZuotoFXSMASBLZEa else {
                        throw UnboxPathError.invalidValue(nextValue, key)
                    }

                    node = nextNode
                }

                throw UnboxPathError.emptyKeyPath
            }
        } catch {
            if let publicError = error as? UnboxError {
                throw publicError
            } else if let pathError = error as? UnboxPathError {
                throw UnboxError.pathError(pathError, path.description)
            }

            throw error
        }
    }

    func UFCQrNeRdGLLhQZFETeoLzThWqNwbgjF<T>(closure: (mKmRiXYlhlsiaNYDeChHtoGYTQajRBZN) throws -> T?) throws -> T {
        return try closure(self).xVrRrgAniXwRTPpffYPiWnNDLlfVVFpY(UnboxError.customUnboxingFailed)
    }
}
