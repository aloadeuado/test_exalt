//
//  DateSelectedView.swift
//  test_yummy
//
//  Created by pedro.daza on 24/10/21.
//

import UIKit

class ButtonSelectView: CustomShowView{

    override var nameXIB: String { "ButtonSelectView" }
    var pressedSelect: ((UIButton, String) -> Void)?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: CustomButton!
    var state: Bool = false{
        didSet{
            setStateDisplay()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func pressed(button: UIButton) {
        pressedSelect?(button, label.text ?? "")
    }
    private func setStateDisplay(){
        if state {
            contentView.layer.cornerRadius = 12
            contentView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.3529411765, blue: 0, alpha: 0.5089857659)
            label.textColor = #colorLiteral(red: 0.9607843137, green: 0.3529411765, blue: 0, alpha: 1)
        } else {
            contentView.layer.cornerRadius = 12
            contentView.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 0.4784183632)
            label.textColor = #colorLiteral(red: 0.4470588235, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
        }
    }
}
