//
//  Currency.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

// MARK: - Currency
struct Currency: Codable {
    let meta: Meta?
    let data: [String: Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let code: String?
    let value: Double?
}

// MARK: - Meta
struct Meta: Codable {
    let lastUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedAt = "last_updated_at"
    }
}
