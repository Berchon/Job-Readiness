//
//  NetworkManager.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 21/09/22.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

protocol DataTaskProtocol {
    func wrappedDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

//struct NetworkError: Error { }

final class NetworkManager: NetworkManagerProtocol {
    private let session: DataTaskProtocol
    
    init(session: DataTaskProtocol) {
        self.session = session
    }
    
    func request<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        session.wrappedDataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(APIError.NetworkBadRequest))
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse,
                  httpUrlResponse.statusCode == 200 else {
                completion(.failure(APIError.NetworkResponseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.NetworkInvalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decode = try decoder.decode(T.self, from: data)
                completion(.success(decode))
            } catch {
                completion(.failure(APIError.NetworkInvalidData))
            }
        }
    }
}

extension URLSession: DataTaskProtocol {
    func wrappedDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
}
