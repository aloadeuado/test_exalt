//
//  SearchBarView.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import UIKit
protocol SearchBarViewDelegate {
    func onGetText(text: String)
    func onClearText()
}
class SearchBarView: CustomShowView {

    override var nameXIB: String {"SearchBarView"}
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textFiedl: UITextField!
    
    var delegate: SearchBarViewDelegate?
    override func initComponents() {
        super.initComponents()
        clearButton.isHidden = true
    }

    @IBAction func onClearText(button: UIButton) {
        textFiedl.text = ""
        delegate?.onClearText()
        clearButton.isHidden = true
    }
}
//MARK: -UITextFieldDelegate
extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.onGetText(text: textField.text ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onGetText(text: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !((textField.text ?? "") + string).isEmpty {
            clearButton.isHidden = false
        } else {
            clearButton.isHidden = true
        }
        return true
    }
}
