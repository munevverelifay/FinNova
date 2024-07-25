//
//  NetworkManager.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol NetworkManagerInterface {
    func getCurrency(completion: @escaping (Result<Currency, ErrorTypes>) -> Void)
}

class NetworkManager: NetworkManagerInterface {
    var networkManager: CoreNetworkManagerInterface = CoreNetworkManager()
    
    func getCurrency(completion: @escaping (Result<Currency, ErrorTypes>) -> Void) {
        let endopoint = Endpoint.getCurrency
        networkManager.request(endopoint, completion: completion)
    }
}
