//
//  BudgetItem.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

struct BudgetItem: Codable {
    let userId: String
    let date: String
    let type: String
    let source: String
    let amount: String
    let currency: String
}


