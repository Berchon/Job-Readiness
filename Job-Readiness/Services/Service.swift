//
//  Service.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

class Service {
    let network = Network()

    func getToken(completion: @escaping (AuthorizationModel?, Error?) -> Void) {
        let urlBase = "https://api.mercadolibre.com"
        let path = "/oauth/token"
        let url = urlBase + path

        let params: [String: String] = [
            "accept": "application/json",
            "content-type": "application/x-www-form-urlencoded",
        ]
        let headers: [String: String] = [:]
        let body: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": "4081270747201707",
            "client_secret": "5iHNb93GGJ25TCTHhyApqDltyc4aIAxK",
            "code": "TG-632774aec3025f000104cfc8-1169220274",
            "redirect_uri": "https://www.alkemy.org/",
        ]

        network.post(urlString: url, params: params, headers: headers, body: body) { autorization, error in
            if let _ = error {
                completion(nil, error)
                return
            }
            completion(autorization, nil)
        }
    }
    
    func getCategory(category: String, authorization: String, completion: @escaping (CategoriesModel?, Error?) -> Void) {
        let urlBase = "https://api.mercadolibre.com"
        let path = "/sites/MLB/domain_discovery/search"
        let url = urlBase + path
        
        let params: [String: String] = [
            "q": category,
            "limit": "1",
        ]
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorization)"
        ]
        let body: [String: String] = [:]
        
        network.get(type: "CategoriesModel" ,urlString: url, authorization: authorization, params: params, headers: headers, body: body) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let categories = result as? CategoriesModel else {
                completion(nil, APIError.NetworkInvalidData)
                return
            }
            completion(categories, nil)
        }
    }
    
    func getProducts(categoryId: String, authorization: String, completion: @escaping (ProductsModel?, Error?) -> Void) {
        let urlBase = "https://api.mercadolibre.com"
        let path = "/highlights/MLB/category/"
        let url = urlBase + path + categoryId
        
        let params: [String: String] = [:]
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorization)"
        ]
        let body: [String: String] = [:]
        
        network.get(type: "ProductsModel", urlString: url, authorization: authorization, params: params, headers: headers, body: body) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let products = result as? ProductsModel else {
                completion(nil, APIError.NetworkInvalidData)
                return
            }
            completion(products, nil)
        }
    }
    
    func getProductsDetails(with param: String, authorization: String, completion: @escaping (ProductsDetailsModel?, Error?) -> Void) {
        let urlBase = "https://api.mercadolibre.com"
        let path = "/items"
        let url = urlBase + path
        
        let params: [String: String] = [ "ids": param ]
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorization)"
        ]
        let body: [String: String] = [:]
        
        network.get(type: "ProductsDetailsModel", urlString: url, authorization: authorization, params: params, headers: headers, body: body) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let productsDescription = result as? ProductsDetailsModel else {
                completion(nil, APIError.NetworkInvalidData)
                return
            }
            completion(productsDescription, nil)
        }
    }
}
