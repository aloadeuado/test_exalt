//
//  AlertsNative.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit

class AlertsNative {
    static func showSimpleAlertNoAction(titleText: String, subTitleText: String, textButton: String = "Ok") {
        let alert = UIAlertView()
        alert.title = titleText
        alert.message = subTitleText
        alert.addButton(withTitle: textButton)
        alert.show()
    }
}
