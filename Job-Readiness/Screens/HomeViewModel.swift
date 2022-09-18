//
//  HomeViewModel.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 14/09/22.
//

import Foundation
import UIKit

class HomeViewModel {
    weak var delegate: HomeViewControllerProtocol?
    
    var products: [Product] = []
    let service = Service()
    var token: String = "APP_USR-4081270747201707-091815-08159017fdd5af49b9ef186aa81e8137-1169220274"
    var categories = CategoriesModel()
    var productsByCategory: ProductsModel = {
        return ProductsModel(content: [])
    }()
    var productsDetails = ProductsDetailsModel()

    init() {
        
    }
    
    func clearPropertiesFromApi() {
        categories = CategoriesModel()
        productsByCategory.content = []
        productsDetails = ProductsDetailsModel()
    }
    
    func count() -> Int {
        return products.count
    }
    
    func getProduct(index: Int) -> Product {
        return products[index]
    }
    
    func searchProducts(category: String) {
        clearPropertiesFromApi()
        let group = DispatchGroup()
        
        group.enter()
        getCategory(category: category) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let id = self.categories.first?.categoryId {
                self.searchProductsWithCategoryId(using: id)
            }
        }
    }
    
    func searchProductsWithCategoryId(using id: String) {
        let group = DispatchGroup()

        group.enter()
        self.getProducts(categoryId: id) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.searchProductsDetailsUsing(productsByCategory: self.productsByCategory)
        }
    }
    
    func searchProductsDetailsUsing(productsByCategory: ProductsModel) {
        let group = DispatchGroup()

        group.enter()
        self.getProductsDetails(with: productsByCategory) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.configureTableViewData()
        }
    }
    
    func configureTableViewData() {
        products = productsDetails.map({ product in
            let name = product.body.title
            let price = String(product.body.price)
            let description1 = product.body.subtitle ?? String("---")
            let description2 = product.body.descriptions.first ?? String("---")
            let productImage = UIImageView(image: UIImage(systemName: "giftcard.fill"))
            let product = Product(name: name, price: price, description1: description1, description2: description2, productImage: productImage)

            return product
        })
        delegate?.reloadData()
    }

    func getToken() {
        service.getToken { authorization, error in
            if let error = error {
                print("eu tenho um erro")
                print(error)
//                Notification.show(title: "App ID TG inválida", message: "Erro ao gerar o token de acesso!", target: target)
            }
            
            if let authorization = authorization {
                self.token = authorization.accessToken
                print("Buscou o token")
            }
        }
    }
    
    func getCategory(category: String, completion: @escaping () -> Void) {
        service.getCategory(category: category, authorization: token) { categories, error in
            if let error = error {
                print("eu tenho um erro nas categorias")
                print(error)
            }
            
            if let categories = categories {
                self.categories = categories
                print("Buscou categorias")
            }
            completion()
        }
    }
    
    func getProducts(categoryId: String, completion: @escaping () -> Void) {
        service.getProducts(categoryId: categoryId, authorization: token) { products, error in
            if let error = error {
                print("Eu tenho um erro nos produtos")
                print(error)
            }
            
            if let products = products {
                self.productsByCategory = products
                print("Buscou os produtos")
            }
            completion()
        }
    }
    
    func getProductsDetails(with productsByCategory: ProductsModel, completion: @escaping () -> Void) {
        let ids = productsByCategory.content.map { product in
            return product.id
        }
        let params = ids.joined(separator: ",")

        service.getProductsDetails(with: params, authorization: token) { productsDetail, error in
            if let error = error {
                print("Eu tenho um erro nos detalhes")
                print(error)
            }
            
            if let productsDetail = productsDetail {
                self.productsDetails = productsDetail
                print("Buscou os detalhes dos produtos")
            }
            completion()
        }
    }
}
