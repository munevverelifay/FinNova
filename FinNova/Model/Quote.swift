//
//  Quote.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

// MARK: - Quote
struct Quote: Codable {
    let quote, author: String?
}

typealias Quotes = [Quote]
