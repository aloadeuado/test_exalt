//
//  DetailRecipesViewController.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
import SkeletonView
class DetailRecipesViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var intrucctionsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var heigthIngredientsTableView: NSLayoutConstraint!
    
    var detailRecipes: DetailRecipes?
    var result: Result?
    var viewModel: DetailRecipesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }

    func initComponent() {
        ingredientsTableView.register(IngredientsTableViewCell.nib(), forCellReuseIdentifier: IngredientsTableViewCell.identificador)
        viewModel = DetailRecipesViewModel(detailRecipesViewToViewModel: self)
        showSkeletor()
        viewModel?.getDetailRecipes(controller: self, idRecipes: result?.id ?? 0)
    }
    
    @IBAction func closePressed(button: UIButton) {
        self.dismiss(animated: true)
    }
    
    static func show(controller: UIViewController, result: Result) {
        let detailRecipesViewController = DetailRecipesViewController(nibName: "DetailRecipesViewController", bundle: nil)
        detailRecipesViewController.result = result
        detailRecipesViewController.modalPresentationStyle = .overFullScreen
        controller.present(detailRecipesViewController, animated: true)
    }
    
    func showSkeletor() {
        imageView.layer.cornerRadius = 8
        titleLabel.layer.cornerRadius = 8
        intrucctionsLabel.layer.cornerRadius = 8
        descriptionLabel.layer.cornerRadius = 8
        creditsLabel.layer.cornerRadius = 8
        
        imageView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
        intrucctionsLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
        creditsLabel.showAnimatedGradientSkeleton()
    }
    
    func showHide() {
        imageView.layer.cornerRadius = 0
        titleLabel.layer.cornerRadius = 0
        intrucctionsLabel.layer.cornerRadius = 0
        descriptionLabel.layer.cornerRadius = 0
        creditsLabel.layer.cornerRadius = 0
        
        imageView.hideSkeleton()
        titleLabel.hideSkeleton()
        intrucctionsLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
        creditsLabel.hideSkeleton()
    }
}
//MARK: -DetailRecipesViewToViewModel
extension DetailRecipesViewController: DetailRecipesViewToViewModel {
    func succesGetDetailRecipe(detailRecipes: DetailRecipes) {
        self.detailRecipes = detailRecipes
        showHide()
        guard let detailRecipes = self.detailRecipes else {
            return
        }
        imageView.sd_setImage(with: NSURL(string: detailRecipes.image ?? "") as URL?)
        titleLabel.text = detailRecipes.title ?? ""
        intrucctionsLabel.attributedText = (detailRecipes.instructions ?? "").htmlToAttributedString
        descriptionLabel.attributedText = (detailRecipes.summary ?? "").htmlToAttributedString
        creditsLabel.text = detailRecipes.creditsText ?? ""
        
        heigthIngredientsTableView.constant = CGFloat((detailRecipes.extendedIngredients?.count ?? 0) * 57)
        ingredientsTableView.reloadData()
    }
    
    func showError(error: String) {
        
    }
    
    
}
//MARK: -UITableViewDataSource
extension DetailRecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecipes?.extendedIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identificador, for: indexPath) as? IngredientsTableViewCell {
            if let detailRecipes = self.detailRecipes, let extendedIngredient = detailRecipes.extendedIngredients {
                cell.setData(extendedIngredient: extendedIngredient[indexPath.row])
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}
