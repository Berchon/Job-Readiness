//
//  Service1.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 21/09/22.
//

import Foundation

protocol DataSourceProtocol {
    func fetchToken(completion: @escaping (Result<AuthorizationModel, Error>) -> Void)
    func fetchCategory(category: String, authorization: String, completion: @escaping (Result<CategoriesModel, Error>) -> Void)
    func fetchProductsDetails(with param: String, authorization: String, completion: @escaping (Result<ProductsDetailsModel, Error>) -> Void)
    func fetchProducts(categoryId: String, authorization: String, completion: @escaping (Result<ProductsModel, Error>) -> Void)
}

final class ApiDataSource: DataSourceProtocol {
    private let network: NetworkManagerProtocol
    private let environment = Environment()
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func fetchToken(completion: @escaping (Result<AuthorizationModel, Error>) -> Void) {
        let urlBase = environment.urlBase
        let path = environment.pathGetToken
        let url = urlBase + path
        
        let method = "POST"
        let params: [String: String] = ["accept": "application/json", "content-type": "application/x-www-form-urlencoded"]
        let headers: [String: String] = [:]
        let body: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": "4081270747201707",
            "client_secret": "5iHNb93GGJ25TCTHhyApqDltyc4aIAxK",
            "code": "TG-632ce5bea8458b000121c54e-1169220274",
            "redirect_uri": "https://www.alkemy.org/",
        ]
        
        do {
            let request = try createRequest(method: method, urlString: url, params: params, headers: headers, body: body)
            network.request(request: request) { (result: Result<AuthorizationModel, Error>) in
                switch result {
                case .success(let authorization):
                    guard authorization.accessToken.isEmpty == false else {
                        completion(.failure(APIError.EmptyDataError))
                        return
                    }
                    completion(.success(authorization))
                case .failure(let error):
                    completion(.failure(error ))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchCategory(category: String, authorization: String, completion: @escaping (Result<CategoriesModel, Error>) -> Void) {
        let urlBase = environment.urlBase
        let path = environment.pathGetCategories
        let url = urlBase + path
        
        let method = "GET"
        let params: [String: String] = ["q": category, "limit": "1"]
        let headers: [String: String] = ["Authorization": "Bearer \(authorization)"]
        let body: [String: String] = [:]
        
        do {
            let request = try createRequest(method: method, urlString: url, params: params, headers: headers, body: body)
            network.request(request: request) { (result: Result<CategoriesModel, Error>) in
                switch result {
                case .success(let categories):
                    guard categories.isEmpty == false else {
                        completion(.failure(APIError.EmptyDataError))
                        return
                    }
                    completion(.success(categories))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchProducts(categoryId: String, authorization: String, completion: @escaping (Result<ProductsModel, Error>) -> Void) {
        let urlBase = environment.urlBase
        let path = environment.pathGetProductsByCategory
        let url = urlBase + path + categoryId
        
        let method = "GET"
        let params: [String: String] = [:]
        let headers: [String: String] = ["Authorization": "Bearer \(authorization)"]
        let body: [String: String] = [:]
        
        do {
            let request = try createRequest(method: method, urlString: url, params: params, headers: headers, body: body)
            network.request(request: request) { (result: Result<ProductsModel, Error>) in
                switch result {
                case .success(let products):
                    guard products.content.isEmpty == false else {
                        completion(.failure(APIError.EmptyDataError))
                        return
                    }
                    completion(.success(products))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchProductsDetails(with param: String, authorization: String, completion: @escaping (Result<ProductsDetailsModel, Error>) -> Void) {
        let urlBase = environment.urlBase
        let path = environment.pathGetProdutsDetails
        let url = urlBase + path
        
        let method = "GET"
        let params: [String: String] = [ "ids": param ]
        let headers: [String: String] = [ "Authorization": "Bearer \(authorization)" ]
        let body: [String: String] = [:]
        do {
            let request = try createRequest(method: method, urlString: url, params: params, headers: headers, body: body)
            network.request(request: request) { (result: Result<ProductsDetailsModel, Error>) in
                switch result {
                case .success(let productsDetails):
                    guard productsDetails.isEmpty == false else {
                        completion(.failure(APIError.EmptyDataError))
                        return
                    }
                    completion(.success(productsDetails))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func createRequest(method: String, urlString: String, params: [String: String], headers: [String: String], body: [String: String]) throws -> URLRequest {
        guard var components = URLComponents(string: urlString) else {
            throw APIError.NetworkInvalidUrl
        }
        
        components.queryItems = params.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = components.url else {
            throw APIError.NetworkInvalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        if body.isEmpty {
            return request
        }
        
        var httpBody: Data
        do {
            httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        } catch {
            throw APIError.NetworkBadRequest
        }
        request.httpBody = httpBody
        return request
    }
}
