//
//  NYCSchoolsWebService.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import Foundation
import Combine

/// API Errors
public enum APIError: Swift.Error {

    case invalidURL
    case httpStatusCode(Int)
    case unexpectedResponse
}

// Extension for API Error
extension APIError: LocalizedError {

    public var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case let .httpStatusCode(code): return "Unexpected HTTP status code: \(code)"
            case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

// MARK: - NYCSchools webeservice protocol
protocol NYCSchoolsWebServiceProtocol {
    // fetch nyc schools list
    func fetchNYCSchools(urlString: String) -> AnyPublisher<[NYCSchoolsModel], Error>
    // fetch schools sat details
    func fetchSchoolSatDetails(urlString: String) -> AnyPublisher<[NYCSchoolSatModel], Error>
}

// MARK: - NYCSchools webeservice

public struct NYCSchoolsWebService: NYCSchoolsWebServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchNYCSchools(urlString: String) -> AnyPublisher<[NYCSchoolsModel], Error> {
        callAPI(urlString: urlString)
    }
    
    func fetchSchoolSatDetails(urlString: String) -> AnyPublisher<[NYCSchoolSatModel], Error> {
        callAPI(urlString: urlString)
    }
    
    public func callAPI<Value>(urlString: String) -> AnyPublisher<Value, Error> where Value: Decodable {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return urlSession
                .dataTaskPublisher(for: url)
                .tryMap { output in
                    guard let statusCode = (output.response as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    
                    guard (200...299).contains(statusCode) else {
                        throw APIError.httpStatusCode(statusCode)
                    }
                    
                    return output.data
                }
                .decode(type: Value.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}
