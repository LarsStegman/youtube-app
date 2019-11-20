//
//  HeteroGeneousCollectionCodable.swift
//  MyTubePlayer
//
//  Source:
//  https://gist.githubusercontent.com/Kdan/270e1ea776c3dd056474261b523b0a56/raw/0cbc98539d2d5337084fdbd87a85dfa8b6cc8828/heterogeneous_decoding.swift
//

import Foundation


/// Discriminator key enum used to retrieve discriminator fields in JSON payloads.
enum CodableTypeDiscriminator: String, CodingKey {
    case type = "type"
}

/// To support a new class family, create an enum that conforms to this protocol and contains the different types.
protocol ClassFamily: Decodable {
    /// The discriminator key.
    static var discriminator: CodableTypeDiscriminator { get }

    /// Returns the class type of the object coresponding to the value.
    func getType() -> AnyObject.Type
}


/// The PetFamily enum describes the Pet family of objects.
//enum PetFamily: String, ClassFamily {
//    case cat = "Cat"
//    case dog = "Dog"
//
//    static var discriminator: CodableTypeDiscriminator = .type
//
//    func getType() -> AnyObject.Type {
//        switch self {
//        case .cat:
//            return Cat.self
//        case .dog:
//            return Dog.self
//        }
//    }
//}

extension JSONDecoder {
    /// Decode a heterogeneous list of objects.
    /// - Parameters:
    ///     - family: The ClassFamily enum type to decode with.
    ///     - data: The data to decode.
    /// - Returns: The list of decoded objects.
    func decode<T: ClassFamily, U: Decodable>(family: T.Type, from data: Data) throws -> [U] {
        return try self.decode([ClassWrapper<T, U>].self, from: data).compactMap { $0.object }
    }

    private class ClassWrapper<T: ClassFamily, U: Decodable>: Decodable {
        /// The family enum containing the class information.
        let family: T
        /// The decoded object. Can be any subclass of U.
        let object: U?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodableTypeDiscriminator.self)
            // Decode the family with the discriminator.
            family = try container.decode(T.self, forKey: T.discriminator)
            // Decode the object by initialising the corresponding type.
            if let type = family.getType() as? U.Type {
                object = try type.init(from: decoder)
            } else {
                object = nil
            }
        }
    }
}

extension KeyedDecodingContainer {

    /// Decode a heterogeneous list of objects for a given family.
    /// - Parameters:
    ///     - family: The ClassFamily enum for the type family.
    ///     - key: The CodingKey to look up the list in the current container.
    /// - Returns: The resulting list of heterogeneousType elements.
    func decode<T : Decodable, U : ClassFamily>(family: U.Type, forKey key: K) throws -> [T] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        var list = [T]()
        var tmpContainer = container
        while !container.isAtEnd {
            let typeContainer = try container.nestedContainer(keyedBy: CodableTypeDiscriminator.self)
            let family: U = try typeContainer.decode(U.self, forKey: U.discriminator)
            if let type = family.getType() as? T.Type {
                list.append(try tmpContainer.decode(type))
            }
        }
        return list
    }
}

