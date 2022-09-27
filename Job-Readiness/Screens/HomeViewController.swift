//
//  HomeViewController.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 13/09/22.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func reloadData()
}

class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "HomeTableViewCell"
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        viewModel.delegate = self
        
//        viewModel.getToken(target: self)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let category = searchBar.text else {
            return
        }
        viewModel.searchProducts(category: category, target: self)
        searchBar.text = String()
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        cell.updateCell(product: viewModel.getProduct(index: index))
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.getProduct(index: indexPath.row)
        let detailsViewController = DetailsViewController(with: product)
        detailsViewController.title = "Descrição do Produto"
        navigationItem.backButtonTitle = String()
        navigationController?.pushViewController(detailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let image = UIImage(systemName: "photo") else {
            return
        }
        guard let url = URL(string: URLAddress) else {
            self.image = image
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            do {
                let imageData = try Data(contentsOf: url)
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            } catch {
                self?.image = image
            }
        }
    }
}
