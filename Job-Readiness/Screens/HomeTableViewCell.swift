//
//  HomeTableViewCell.swift
//  Job-Readiness
//
//  Created by Luciano Da Silva Berchon on 13/09/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteButttonTapped(_ sender: Any) {
        print("Favoritou")
    }
    
    func updateCell(product: Product) {
        productLabel.text = product.name
        priceLabel.text = product.price
        descriptionLabel.text = product.description1
        description2Label.text = product.description2
//        productImage = product.productImage
    }
}
