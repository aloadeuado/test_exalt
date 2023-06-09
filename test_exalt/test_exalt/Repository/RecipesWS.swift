//
//  RecipesWS.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation

struct Recipes {
    static func getListRecipes(text:String, offsetOnPage: Int, numberOfItems: Int, complete: @escaping ((Bool, ListRecipes?, String) -> Void)) {
        let url = getListRecipesUrl().replacingOccurrences(of: "&{text}", with: "\(text)").replacingOccurrences(of: "&{offset}", with: "\(offsetOnPage)").replacingOccurrences(of: "&{number}", with: "\(numberOfItems)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: ListRecipes.self) { success, listRecipes, error in
            DispatchQueue.main.async {
                complete(success, listRecipes, error?.localizedDescription ?? "")
            }
        }
    }
    
    static func getDetailRecipes(idRecipe: Int, complete: @escaping ((Bool, DetailRecipes?, String) -> Void) ) {
        let url = getDetailRecipesUrl().replacingOccurrences(of: "&{idRecipe}", with: "\(idRecipe)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: DetailRecipes.self) { success, detailRecipes, error in
            DispatchQueue.main.async {
                complete(success, detailRecipes, error?.localizedDescription ?? "")
            }
        }
    }
}
