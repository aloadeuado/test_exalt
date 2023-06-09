//
//  ListRecipesViewModel.swift
//  test_exalt
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit
class ListRecipesViewModel {
    var listRecipesViewToViewModel: ListRecipesViewToViewModel?
    init(listRecipesViewToViewModel: ListRecipesViewToViewModel) {
        self.listRecipesViewToViewModel = listRecipesViewToViewModel
    }
}
//MARK: -ListRecipesViewModelToView
extension ListRecipesViewModel: ListRecipesViewModelToView {
    func getListRecipes(controller: UIViewController, text: String, offsetPage: Int, numberPerPage: Int) {
        Recipes.getListRecipes(text: text, offsetOnPage: offsetPage, numberOfItems: numberPerPage) {[weak self] success, listRecipes, error in
            if success {
                guard let self = self, let listRecipes = listRecipes else {return}
                self.listRecipesViewToViewModel?.succesGetListRecipes(listRecipes: listRecipes, text: text)
            } else {
                AlertsNative.showSimpleAlertNoAction(titleText: "Error", subTitleText: error)
            }
        }
    }
    
    func addTextFastSearch(text: String) {
        addTextFastSearchUtil(text: text)
    }
    
    func getTextFastSearch() -> [String] {
        return getTextFastSearchUtil()
    }
    
    func getListFavoriteREcipesIds() -> [Result] {
        return FavoriteDefault.getFavoriteRecipe()
    }
    
    func addAndRemoveFavoriteId(result: Result) {
        FavoriteDefault.addFavoriteRecipe(result: result)
    }
    
    func getListPage(listRecipes: ListRecipes) -> [String] {
        var listText = [String]()
        let listData:Int = (listRecipes.totalResults ?? 0) / 10

        var index1 = 0
        for _ in 0...listData {
            
            index1 += 10
            listText.append("\(index1 - 9)...\(index1)")
        }
        if ((listRecipes.totalResults ?? 0) % 10) > 0 {
            listText.append("\(index1 - 9)...\((listRecipes.totalResults ?? 0))")
        }
        
        return listText
    }
}
