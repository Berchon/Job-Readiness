//
//  PictureModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

struct PictureModel: Codable {
    let url: String
    var secureUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case url
        case secureUrl = "secure_url"
    }
}
