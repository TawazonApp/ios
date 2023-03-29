//
//  Backend.Codable.swift
//  Adapty
//
//  Created by Aleksei Valiano on 08.09.2022.
//

import Foundation

extension Backend {
    enum CodingKeys: CodingKey {
        case data
        case type
        case id
        case attributes
    }
}

extension Encoder {
    func backendContainer<Key>(type: String, keyedBy: Key.Type) throws -> KeyedEncodingContainer<Key> where Key: CodingKey {
        var container = container(keyedBy: Backend.CodingKeys.self)
        var dataObject = container.nestedContainer(keyedBy: Backend.CodingKeys.self, forKey: .data)
        try dataObject.encode(type, forKey: .type)
        return dataObject.nestedContainer(keyedBy: Key.self, forKey: .attributes)
    }
}

extension Backend.Response {
    struct Body<T: Decodable>: Decodable {
        let value: T

        init(_ value: T) {
            self.value = value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Backend.CodingKeys.self)
            let dataObject = try container.nestedContainer(keyedBy: Backend.CodingKeys.self, forKey: .data)
            value = try dataObject.decode(T.self, forKey: .attributes)
        }
    }

    struct ValueOfData<T: Decodable>: Decodable {
        let value: T

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Backend.CodingKeys.self)
            value = try container.decode(T.self, forKey: .data)
        }
    }
}
