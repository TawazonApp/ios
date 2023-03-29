//
//  KinesisEvent.swift
//  Adapty
//
//  Created by Aleksei Valiano on 07.10.2022.
//

import Foundation

struct Event {
    let type: EventType
    let id: String
    let profileId: String
    let sessionId: String
    let createdAt: Date

    fileprivate init(type: EventType,
                     id: String,
                     profileId: String,
                     sessionId: String,
                     createdAt: Date) {
        self.type = type
        self.id = id
        self.profileId = profileId
        self.sessionId = sessionId
        self.createdAt = createdAt
    }

    init(type: EventType, profileId: String) {
        self.init(type: type,
                  id: UUID().uuidString.lowercased(),
                  profileId: profileId,
                  sessionId: Environment.Application.sessionIdentifier,
                  createdAt: Date())
    }
}

extension Event: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "event_name"
        case id = "event_id"
        case profileId = "profile_id"
        case sessionId = "session_id"
        case createdAt = "created_at"
        case appInstallId = "device_id"
        case sysName = "platform"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(profileId, forKey: .profileId)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(Environment.System.name, forKey: .sysName)
        try container.encode(Environment.Application.installationIdentifier, forKey: .appInstallId)
        try type.encode(to: encoder)
    }
}

extension Event {
    fileprivate enum Default {
        static var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()

        static var encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            encoder.dataEncodingStrategy = .base64
            return encoder
        }()
    }

    func encodeToData() throws -> Data { try Default.encoder.encode(self) }
}
