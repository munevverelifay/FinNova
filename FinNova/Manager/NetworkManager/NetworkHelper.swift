//
//  NetworkHelper.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import Foundation

protocol EndpointProtocol {
    var apiToken: String {get}
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var header: [String: String]? {get}
    var parameters: [String: Any]? {get}
    func request() -> URLRequest
}

//MARK: - Endpoints

enum Endpoint { //Endpoint.gerCurrency
    case getCurrency
}

extension Endpoint: EndpointProtocol {
    var apiToken: String {
        return "cur_live_1tyobKd6GQhrF2AzH2KbXGDM4aSQeXoRhsmql5qZ"
    }

    var baseURL: String {
        return "https://api.currencyapi.com"
    }

    var path: String {
        switch self {
        case .getCurrency: return "/v3/latest" //şu an tek endopint var fazla olursa
        }
    }

    var method: HTTPMethod {
        return .get
    }
    

    var header: [String : String]? {
        let header: [String: String] = ["Content-type": "application/json; charset=UTF-8"]
        return header
    }

    var parameters: [String : Any]? {
        return nil //parametrem olmadığı için nil
    }

    func request() -> URLRequest {
        
        //Create url
        guard let url = URL(string: "\(baseURL)\(path)?apikey=\(apiToken)") else {
            fatalError("URL ERROR")
        }
        
        //Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        //Add Paramters
        if let parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = data
            }catch {
             //   Logger.shared.log(text:error.localizedDescription)
                print(error.localizedDescription)
            }
        }
        //Add Header
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}

extension Endpoint: CustomStringConvertible {
    var description: String {
        return """
        Request:
        \(Date())
        -->
           method -> \(method.rawValue)
           parametres -> \(parameters)
           header -> \(header as AnyObject)
        """
    }
}
