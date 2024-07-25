//
//  IncomeExpenseViewModel.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

final class IncomeExpenseViewModel {
    var succesCompletion: ((Currency) -> Void)?
    var failCompletion: (() -> Void)?
    
    var networkManager: NetworkManagerInterface?
    
    init(networkManager: NetworkManagerInterface? = nil) {
        self.networkManager = networkManager
    }
    
    func fetchCurrency() {
        networkManager?.getCurrency(completion: { response in
            self.handleResponse(response: response)
        })
    }
    
    func handleResponse(response: Result<Currency, ErrorTypes>) {
        switch response {
        case .success(let success):
            self.succesCompletion?(success)
        case .failure(_):
            self.failCompletion?()
        }
    }
}

