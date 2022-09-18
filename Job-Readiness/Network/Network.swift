//
//  Network.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

class Network {
    func createRequest(method: String, urlString: String, params: [String: String], headers: [String: String], body: [String: String]) -> (request: URLRequest?, error: Error?) {
        guard var components = URLComponents(string: urlString) else {
            return (nil, APIError.NetworkInvalidUrl)
        }
        
        components.queryItems = params.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = components.url else {
            return (nil, APIError.NetworkInvalidUrl)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        if body.isEmpty {
            return (request, nil)
        }
        
        var httpBody: Data
        do {
            httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        } catch {
            return (nil, APIError.NetworkBadRequest)
        }
        request.httpBody = httpBody
        return (request, nil)
    }
    
    func get(type: String ,urlString: String, authorization: String, params: [String: String], headers: [String: String], body: [String: String], completion: @escaping (Any?, Error?) -> Void) {
        let requestTupple = createRequest(method: "GET", urlString: urlString, params: params, headers: headers, body: body)
        
        if let error = requestTupple.error {
            completion(nil, error)
            return
        }
        guard let request = requestTupple.request else {
            completion(nil, APIError.NetworkBadRequest)
            return
        }
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(nil, APIError.NetworkBadRequest)
                return
            }

            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200 else {
                completion(nil, APIError.NetworkResponseError)
                return
            }
            
            guard let data = data else {
                completion(nil, APIError.NetworkInvalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if type == "CategoriesModel" {
                    let decode = try decoder.decode(CategoriesModel.self, from: data)
                    completion(decode, nil)
                }
                else if type == "ProductsModel" {
                    let decode = try decoder.decode(ProductsModel.self, from: data)
                    completion(decode, nil)
                }
                else if type == "ProductsDetailsModel" {
                    let decode = try decoder.decode(ProductsDetailsModel.self, from: data)
                    completion(decode, nil)
                }
                else {
                    completion(nil, APIError.NetworkInvalidData)
                }
            } catch {
                //Avisar a Karen
                completion(nil, APIError.NetworkInvalidData)
            }
        }
        session.resume()
    }
    
    func post(urlString: String, params: [String: String], headers: [String: String], body: [String: String], completion: @escaping (AuthorizationModel?, Error?) -> Void) {
        let requestTupple = createRequest(method: "POST", urlString: urlString, params: params, headers: headers, body: body)
        
        if let error = requestTupple.error {
            completion(nil, error)
            return
        }
        guard let request = requestTupple.request else {
            completion(nil, APIError.NetworkBadRequest)
            return
        }
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(nil, APIError.NetworkBadRequest)
                return
            }

            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200 else {
                completion(nil, APIError.NetworkResponseError)
                return
            }
            
            guard let data = data else {
                completion(nil, APIError.NetworkInvalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decode = try decoder.decode(AuthorizationModel.self, from: data)
                completion(decode, nil)
            } catch {
                completion(nil, APIError.NetworkInvalidData)
            }
        }
        session.resume()
    }
}
