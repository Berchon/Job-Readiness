//
//  ProductDescriptionModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

struct ProductDescriptionModel: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let price: Double
    var currencyId: String
    var availableQuantity: Int
    let permalink: String
    let thumbnail: String
    var secureThumbnail: String
    let pictures: [PictureModel]
    let descriptions: [String]
    let status: String
    
    private enum CodingKeys : String, CodingKey {
        case id, title, subtitle, price, permalink, thumbnail, pictures, descriptions, status
        case currencyId = "currency_id"
        case availableQuantity = "available_quantity"
        case secureThumbnail = "secure_thumbnail"

    }
}
