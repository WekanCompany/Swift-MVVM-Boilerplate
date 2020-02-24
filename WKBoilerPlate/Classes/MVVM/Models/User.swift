//
//  User.swift
//  WKBoilerPlate
//
//  Created by Brian on 09/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class User: Codable {
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var offline: Bool?
    var accessToken: String?
    var refreshToken: String?
    var password: String?

    private enum CodingKeys: String, CodingKey {
        case userId = "_id"
        case firstName
        case lastName
        case email
        case offline
        case accessToken
        case refreshToken
        case password
    }

    init() {
    }

    // MARK: - Codable

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(offline, forKey: .offline)
        try container.encodeIfPresent(accessToken, forKey: .accessToken)
        try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
        try container.encodeIfPresent(password?.sha512(), forKey: .password)
   }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        offline = try container.decodeIfPresent(Bool.self, forKey: .offline)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        password = try container.decodeIfPresent(String.self, forKey: .password)
    }
}
