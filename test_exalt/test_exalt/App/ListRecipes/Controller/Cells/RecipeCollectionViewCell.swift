//
//  RecipeCollectionViewCell.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
import SkeletonView
protocol RecipeCollectionViewCellDelegate: AnyObject {
    func onAddAndRemoveFavorite(result: Result)
}
class RecipeCollectionViewCell: UICollectionViewCell {

    static let  identificador = "RecipeCollectionViewCell"
    static func nib() -> UINib  {   return UINib(nibName: "RecipeCollectionViewCell", bundle: Bundle(for: RecipeCollectionViewCell.self))  }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var favoriteActiveImageView: UIImageView!
    @IBOutlet weak var favoriteInactiveImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: RecipeCollectionViewCellDelegate?
    var result: Result?
    var isFavorite: Bool = false {
        didSet{
            if isFavorite {
                favoriteActiveImageView.isHidden = false
                favoriteInactiveImageView.isHidden = true
            } else {
                favoriteActiveImageView.isHidden = true
                favoriteInactiveImageView.isHidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(baseUrl:String, result: Result) {
        self.result = result
        imageView.sd_setImage(with: URL(string: baseUrl + (result.image ?? "") ?? ""))
        titleLabel.text = result.title
        subTitleLabel.text = "listo en \(result.readyInMinutes ?? 0) minutos.\nvisita tambien la url \(result.sourceURL ?? "")"
    }
    
    @IBAction func favoriteOnPressed(button: UIButton) {
        if let result = self.result {
            delegate?.onAddAndRemoveFavorite(result: result)
        }
        
    }
    
    func showSkeletor(){
        self.imageView.layer.cornerRadius = 8
        self.favoriteActiveImageView.layer.cornerRadius = 8
        self.favoriteInactiveImageView.layer.cornerRadius = 8
        self.titleLabel.layer.cornerRadius = 8
        self.subTitleLabel.layer.cornerRadius = 8
        
        self.imageView.showAnimatedGradientSkeleton()
        self.favoriteActiveImageView.showAnimatedGradientSkeleton()
        self.favoriteInactiveImageView.showAnimatedGradientSkeleton()
        self.titleLabel.showAnimatedGradientSkeleton()
        self.subTitleLabel.showAnimatedGradientSkeleton()
    }
    
    func hidSkeletor(){
        self.imageView.layer.cornerRadius = 0
        self.favoriteActiveImageView.layer.cornerRadius = 0
        self.favoriteInactiveImageView.layer.cornerRadius = 0
        self.titleLabel.layer.cornerRadius = 0
        self.subTitleLabel.layer.cornerRadius = 0
        self.imageView.hideSkeleton()
        self.favoriteActiveImageView.hideSkeleton()
        self.favoriteInactiveImageView.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.subTitleLabel.hideSkeleton()
    }
}
