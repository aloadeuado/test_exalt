//
//  IngredientsTableViewCell.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
class IngredientsTableViewCell: UITableViewCell {

    static let  identificador = "IngredientsTableViewCell"
    static func nib() -> UINib  {   return UINib(nibName: "IngredientsTableViewCell", bundle: Bundle(for: IngredientsTableViewCell.self))  }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(extendedIngredient: ExtendedIngredient) {
        photoImageView.sd_setImage(with: NSURL(string: "https://spoonacular.com/recipeImages/\(extendedIngredient.image ?? "")") as URL?)
        titleLabel.text = extendedIngredient.name ?? ""
        subTitleLabel.text = "Count \(extendedIngredient.amount ?? 0) \(extendedIngredient.unit ?? "")"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
