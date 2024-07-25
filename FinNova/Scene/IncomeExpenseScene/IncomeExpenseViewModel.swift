//
//  IncomeExpenseViewModel.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol IncomeExpenseViewModelInterface {
}

final class IncomeExpenseViewModel: IncomeExpenseViewModelInterface {
    var succesCompletion: ((Currency) -> Void)?
    var failCompleetion: (() -> Void)?
    
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
            self.failCompleetion?()
        }
    }
}

