//
//  DetailsViewController.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 19/09/22.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var descriptinTextView: UITextView!
    
    let product: Product
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.loadFrom(URLAddress: product.urlImage)
        titleLabel.text = product.name
        priceLabel.text = "$ \(product.price)"
        descriptinTextView.text = "\(product.description1)\n\(product.description1)"
    }


    init(with product: Product) {
        self.product = product
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
