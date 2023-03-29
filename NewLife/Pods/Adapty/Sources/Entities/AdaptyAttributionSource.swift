//
//  AdaptyAttributionSource.swift
//  Adapty
//
//  Created by Aleksei Valiano on 24.09.2022.
//

import Foundation

public enum AdaptyAttributionSource: String, Equatable, Sendable {
    case adjust
    case appsflyer
    case branch
    case appleSearchAds = "apple_search_ads"
    case custom
}

extension AdaptyAttributionSource: CustomStringConvertible {
    public var description: String { rawValue }
}

extension AdaptyAttributionSource: Codable {
    public init(from decoder: Decoder) throws {
        guard let value = AdaptyAttributionSource(rawValue: try decoder.singleValueContainer().decode(String.self)) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "unknown value"))
        }
        self = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
