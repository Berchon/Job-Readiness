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
//    let delegate: HomeViewControllerProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        searchBar.delegate = self
        viewModel.delegate = self
        viewModel.getToken()
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let category = searchBar.text else {
            return
        }
        viewModel.searchProducts(category: category)
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
