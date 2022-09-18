//
//  ProductDetailsModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation

typealias ProductsDetailsModel = [ProductDetailsModel]

struct ProductDetailsModel: Codable {
    let body: ProductDescriptionModel
}
