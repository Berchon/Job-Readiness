//
//  CategoryModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

typealias CategoriesModel = [CategoryModel]

struct CategoryModel: Codable {
    var categoryId: String
    var categoryName: String

    private enum CodingKeys : String, CodingKey {
        case categoryId = "category_id"
        case categoryName = "category_name"
    }
}
