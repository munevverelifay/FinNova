//
//  NetworkManager.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol NetworkManagerInterface {
    func getCurrency(completion: @escaping (Result<Currency, ErrorTypes>) -> Void)
    func getQuotes(completion: @escaping (Result<Quotes, ErrorTypes>) -> Void)
    func getBudgets(completion: @escaping (Result<BudgetItem, ErrorTypes>) -> Void)
}

class NetworkManager: NetworkManagerInterface {
    var networkManager: CoreNetworkManagerInterface = CoreNetworkManager()
    
    func getCurrency(completion: @escaping (Result<Currency, ErrorTypes>) -> Void) {
        let endopoint = Endpoint.getCurrency
        networkManager.request(endopoint, completion: completion)
    }
    
    func getQuotes(completion: @escaping (Result<Quotes, ErrorTypes>) -> Void) {
        networkManager.readMock(completion: completion)
    }
    
    func getBudgets(completion: @escaping (Result<BudgetItem, ErrorTypes>) -> Void) {
        networkManager.readMock(completion: completion)
    }
}
