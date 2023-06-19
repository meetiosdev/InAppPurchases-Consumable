//
//  ProductTableCell.swift
//  InAppPurchases-Consumable
//
//  Created by Swarajmeet Singh on 11/06/23.
//

import UIKit
import StoreKit
class ProductTableCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product : SKProduct!{
        didSet{
            self.productNameLabel.text = product.localizedTitle
            self.descriptionLabel.text = product.localizedDescription
            self.priceLabel.text = "\(product.priceLocale.currencySymbol ?? "") \(product.price)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
