//
//  FavoriteDefault.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
class FavoriteDefault {
    static func addFavoriteRecipe(result: Result) {
        let defaults = UserDefaults.standard
        if var data = defaults.object(forKey: "kFavorite") as? Data {
            if var listIdsFavorites = try? JSONDecoder().decode([Result].self, from: data) {
                if let id = result.id {
                    if listIdsFavorites.first { result in
                        return result.id == id
                    } == nil {
                        listIdsFavorites.append(result)
                    } else {
                        listIdsFavorites.removeAll { result in
                            return result.id == id
                        }
                    }
                }
                if let encoded = try? JSONEncoder().encode(listIdsFavorites) {
                    defaults.set(encoded, forKey: "kFavorite")
                }
            }
        } else {
            if let id = result.id {
                if let encoded = try? JSONEncoder().encode([result]) {
                    defaults.set(encoded, forKey: "kFavorite")
                }
            }
        }
    }
    
    static func getFavoriteRecipe() -> [Result] {
        let defaults = UserDefaults.standard
        if var data = defaults.object(forKey: "kFavorite") as? Data {
            if var listIdsFavorites = try? JSONDecoder().decode([Result].self, from: data) {
                return listIdsFavorites
            }
        }
        return []
    }
}
