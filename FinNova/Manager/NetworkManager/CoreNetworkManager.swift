//
//  CoreNetworkManager.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol CoreNetworkManagerInterface {
    func request<T: Codable>(_ endpoint: Endpoint,completion: @escaping((Result<T,ErrorTypes>)->()))
    func readMock<T: Codable>(completion: @escaping (Result<T,ErrorTypes>)->())
}

public final class CoreNetworkManager: CoreNetworkManagerInterface {
    
    public init() {}
    //model bağımsız generic bir request fonksiyonu
    func request<T: Codable>(_ endpoint: Endpoint, completion: @escaping (Result<T, ErrorTypes>) -> Void) {
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            var result: Result<T, ErrorTypes> = .failure(.generalError)
            print(endpoint.description)
            defer {
                completion(result)
            }
            if error != nil {
                print(ErrorTypes.generalError.rawValue)
                result = .failure(.generalError)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                result = .failure(.generalError)
                return
            }
            
            switch response.statusCode {
            case 200...299:
                self.handleResponse(data: data) { response in
                    result = response
                }
            case 300...399:
                result = .failure(.redirectionError300)
            case 400...499:
                result = .failure(.clientError400)
            default:
                result = .failure(.generalError)
            }
        }
        task.resume()
    }
    
    // MARK: Handle func
    private func handleResponse<T: Codable>(data: Data?, completion: @escaping ((Result<T, ErrorTypes>) -> Void)) {
        guard let data = data else {
            completion(.failure(.emptyData))
            return
        }
        
        do {
            let successData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(successData))
            print("""
                  Response: ->
                    \(Date())
                  -->
                    \(successData)
                  """)
        } catch {
            print(error)
            completion(.failure(.parsingError))
        }
    }
    
    func readMock<T: Codable>(completion: @escaping (Result<T,ErrorTypes>) -> Void) {
        var fileName = ""
        
        switch T.self {
        case is Quotes.Type:
            fileName = "QuoteMockData"
        case is [BudgetItem].Type:
            fileName = "IncomeExpenseMockData"
        default:
            break
        }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(.fileNotFound))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            handleMockResponse(data: data, model: T.self, completion: completion)
        } catch {
            completion(.failure(.parsingError))
        }
    }
    
    private func handleMockResponse<T: Codable>(data: Data?, model: T.Type, completion: @escaping ((Result<T, ErrorTypes>) -> ())) {
        guard let data = data else {
            completion(.failure(.emptyData))
            return
        }
        
        do {
            let successData = try JSONDecoder().decode(model, from: data)
            completion(.success(successData))
            print("""
                  Response: ->
                    \(Date())
                  -->
                    \(successData)
                  """)
        } catch {
            print(error)
            completion(.failure(.parsingError))
        }
    }
}

