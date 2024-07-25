//
//  CoreNetworkManager.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol CoreNetworkManagerInterface {
    func request<T: Codable>(_ endpoint: Endpoint,completion: @escaping((Result<T,ErrorTypes>)->()))
}

public final class CoreNetworkManager: CoreNetworkManagerInterface {
    
    public init() {}
    //model bağımsız generic bir request fonlsiyonu
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
            
            guard let response = response as? HTTPURLResponse else { //responseun optionallığını, oluşuğ oluşmadığını kontrol ettim.
                result = .failure(.generalError)
                return
            }
            
            switch response.statusCode {
            case 200...299: // genel ok
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
        task.resume() // taskı biti?
    }
    
    // MARK: Handle func
    private func handleResponse<T: Codable>(data: Data?, completion: @escaping ((Result<T, ErrorTypes>) -> Void)) {
        guard let data = data else {
            completion(.failure(.emptyData))
            return
        }
        
        do { // önde do sonra hata olursa catch
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
}

class MockSercvice {
    func get(completion: @escaping (Result<jsonModel,Error>) -> Void) {
        
        guard let data = MockJsonParser.shared.request(jsonStr: json1, model: jsonModel.self) else {
            completion(.failure(NSError.init()))
            return
        }
        completion(.success(data))
    }
}

class MockJsonParser {

    static let shared = MockJsonParser()

    func request<T: Codable>(jsonStr: String, model: T.Type) -> T?{
        guard let data = jsonStr.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

let json1 = """
{
    "str": "Örnek metin"
}
"""

struct jsonModel: Codable {
    let str: String?
}
