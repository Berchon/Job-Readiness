//
//  Environment.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 21/09/22.
//

import Foundation

enum EnvironmentEnum {
    case development
    case staging
    case production
    case test
}

class Environment {
    static let shared = Environment()
    let environmentManager: EnvironmentEnum = .development
    
    let urlBase: String
    let pathGetToken: String
    let pathGetCategories: String
    let pathGetProductsByCategory: String
    let pathGetProdutsDetails: String
    
    init() {
        switch environmentManager {
        case .development:
            urlBase = "https://api.mercadolibre.com"
            pathGetToken = "/oauth/token"
            pathGetCategories = "/sites/MLB/domain_discovery/search"
            pathGetProductsByCategory = "/highlights/MLB/category/"
            pathGetProdutsDetails = "/items"
        case .staging, .production, .test:
            urlBase = ""
            pathGetToken = ""
            pathGetCategories = ""
            pathGetProductsByCategory = ""
            pathGetProdutsDetails = ""
        }
    }
}
