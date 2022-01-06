//
//  CodableModelInitializer.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

protocol ModelInitializable {
    
    init?(data: Data)
    
}

extension ModelInitializable where Self: Codable {
    
    init?(data: Data) {
        do {
            self = try newJSONDecoder().decode(Self.self, from: data)
        } catch  {
            print("error ==> \(String(describing: Self.self)) \(error)")
            return nil
        }
        
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    
    func jsonData() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.serverFormat)
        return try? encoder.encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = self.jsonData() else { return nil }
        return String(data: data, encoding: encoding)
    }
    
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.serverFormat)
    return decoder
}
