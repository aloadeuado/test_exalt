//
//  SearchDefault.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
import UIKit

func addTextFastSearchUtil(text: String) {
    if text.isEmpty {
        return
    }
    let defaults = UserDefaults.standard
    if var data = defaults.object(forKey: "kListSeacrh") as? [String] {
        if !data.contains(text) {
            data.append(text)
        }
        defaults.set(data, forKey: "kListSeacrh")
    } else {
        let data = [text]
        defaults.set(data, forKey: "kListSeacrh")
    }
}

func getTextFastSearchUtil() -> [String] {
    let defaults = UserDefaults.standard
    if var data = defaults.object(forKey: "kListSeacrh") as? [String] {

        return data
    }
    
    return []
}
