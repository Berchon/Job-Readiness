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
    private let service: DataSourceProtocol
    var token: String = "APP_USR-4081270747201707-092315-1cb7e67bbefbcf615bb5e978aa3a3e1a-1169220274"
    var categories = CategoriesModel()
    var productsByCategory: ProductsModel = {
        return ProductsModel(content: [])
    }()
    var productsDetails = ProductsDetailsModel()
    var requestError: APIError? = nil

    init() {
        let session = URLSession(configuration: .default)
        let network = NetworkManager(session: session)
        service = ApiDataSource(network: network)
    }
    
    func clearPropertiesFromApi() {
        categories = CategoriesModel()
        productsByCategory.content = []
        productsDetails = ProductsDetailsModel()
        return
    }
    
    func count() -> Int {
        return products.count
    }
    
    func getProduct(index: Int) -> Product {
        return products[index]
    }
    
    func searchProducts(category: String, target: UIViewController) {
        DispatchQueue.main.async {
            self.clearPropertiesFromApi()
            let group = DispatchGroup()

            group.enter()
            self.getCategory(category: category, target: target) {
                group.leave()
            }
            group.wait()

            if let error = self.requestError {
                Notification.show(title: "Erro em buscar dados",
                                  message: "Erro ao buscar o ID da categoria digitada.\n\nCódigo do Erro: \(error).",
                                  target: target)
                return
            }
            guard let id = self.categories.first?.categoryId else {
                return
            }
            
            group.enter()
            self.getProducts(categoryId: id, target: target) {
                group.leave()
            }
            group.wait()

            if let error = self.requestError {
                Notification.show(title: "Erro em buscar dados",
                                  message: "Erro ao buscar os produtos da categoria digitada.\n\nCódigo do Erro: \(error).",
                                  target: target)
                return
            }
            
            group.enter()
            self.getProductsDetails(with: self.productsByCategory, target: target) {
                group.leave()
            }

            group.notify(queue: .main) {
                if let error = self.requestError {
                    Notification.show(title: "Erro em buscar dados",
                                      message: "Erro ao buscar os detalhes dos produtos.\n\nCódigo do Erro: \(error).",
                                      target: target)
                } else {
                    self.configureTableViewData()
                }
            }
        }
    }

    func configureTableViewData() {
        products = productsDetails.map({ product in
            let name = product.body.title
            let price = String(product.body.price)
            let description1 = product.body.subtitle ?? String("---")
            let description2 = product.body.descriptions.first ?? String("---")
            let productImage = UIImageView(image: UIImage(systemName: "photo"))
            let urlThambnail = product.body.thumbnail
            let urlImage = product.body.pictures.first?.url ?? String()
            let product = Product(name: name, price: price, description1: description1, description2: description2, productImage: productImage, urlThumbnail: urlThambnail, urlImage: urlImage)

            return product
        })
        delegate?.reloadData()
    }

    func getToken(target: UIViewController) {
        let group = DispatchGroup()

        group.enter()
        service.fetchToken { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authorization):
                    print(authorization)
                    self.token = authorization.accessToken
                case .failure:
                    self.token = String()
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            if self.token.isEmpty {
                Notification.show(title: "App ID TG inválida", message: "Erro ao gerar o token de acesso!", target: target)
            }
        }
    }
    
    func getCategory(category: String, target: UIViewController, completion: @escaping () -> Void) {
        service.fetchCategory(category: category, authorization: token) { result in
            switch result {
            case .success(let categories):
                self.requestError = nil
                self.categories = categories
            case .failure(let error):
                self.requestError = error as? APIError
                self.categories = []
            }
            completion()
        }
    }
    
    func getProducts(categoryId: String, target: UIViewController, completion: @escaping () -> Void) {
        service.fetchProducts(categoryId: categoryId, authorization: token) { result in
            switch result {
            case .success(let products):
                self.requestError = nil
                self.productsByCategory = products
            case .failure(let error):
                self.requestError = error as? APIError
                self.productsByCategory.content = []
            }
            completion()
        }
    }
    
    func getProductsDetails(with productsByCategory: ProductsModel, target: UIViewController, completion: @escaping () -> Void) {
        let ids = productsByCategory.content.map { product in
            return product.id
        }
        let params = ids.joined(separator: ",")
        
        service.fetchProductsDetails(with: params, authorization: token) { result in
            switch result {
            case .success(let productsDetails):
                self.requestError = nil
                self.productsDetails = productsDetails
            case .failure(let error):
                self.requestError = error as? APIError
                self.productsDetails = []
            }
            completion()
        }
    }
}
