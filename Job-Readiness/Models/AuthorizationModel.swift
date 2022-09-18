//
//  AuthorizationModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

struct AuthorizationModel: Codable {
    var accessToken: String
    
    private enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
    }
}
