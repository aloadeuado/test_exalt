//
//  DetailRecipesViewModel.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
import UIKit
class DetailRecipesViewModel {
    var detailRecipesViewToViewModel: DetailRecipesViewToViewModel?
    init(detailRecipesViewToViewModel: DetailRecipesViewToViewModel) {
        self.detailRecipesViewToViewModel = detailRecipesViewToViewModel
    }
}
//MARK: -DetailRecipesViewModelToView
extension DetailRecipesViewModel: DetailRecipesViewModelToView {
    func getDetailRecipes(controller: UIViewController, idRecipes: Int) {
        Recipes.getDetailRecipes(idRecipe: idRecipes) { [weak self] success, detailRecipes, error in
            guard let self = self else {return}
            if success {
                guard let detailRecipes = detailRecipes else {return}
                self.detailRecipesViewToViewModel?.succesGetDetailRecipe(detailRecipes: detailRecipes)
            } else {
                AlertsNative.showSimpleAlertNoAction(titleText: "Error", subTitleText: error)
            }
        }
    }
}
