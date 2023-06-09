//
//  DateSelectedView.swift
//  test_yummy
//
//  Created by pedro.daza on 24/10/21.
//

import UIKit
protocol DateSelectedViewDelegate: class {
    func dateSelectedView(dateSelectedView: DateSelectedView, didSelectIndex index:Int, text: String)
}
class DateSelectedView: CustomShowView {

    override var nameXIB: String { "DateSelectedView" }
    
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var widthGeneralView: NSLayoutConstraint!

    @IBInspectable var indexDefault:Int = 0
    private var dateButtonsList = [ButtonSelectView]()
    var textList = [String]() {
        didSet{
            //initComponents()
            //loadViews()
        }
    }
    var delegate: DateSelectedViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func initComponents() {
        
    }
    
    func loadViews(){
        generalView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        dateButtonsList = [ButtonSelectView]()
        var i = 0
        var initX: CGFloat = 10
        let spaceX: CGFloat = 10
        let spaceY: CGFloat = 16
        let height: CGFloat = 30
        let width: CGFloat = 80
        for text in textList {
            let buttonSelectView = ButtonSelectView(frame: CGRect(x: initX, y: spaceY, width: width, height: height))
            
            buttonSelectView.tag = i
            buttonSelectView.button.tag = i
            buttonSelectView.label.text = text
            buttonSelectView.pressedSelect = {button, text in
                self.selectIndex(index: button.tag)
                self.delegate?.dateSelectedView(dateSelectedView: self, didSelectIndex: button.tag, text: text)
            }
            generalView.addSubview(buttonSelectView)
            dateButtonsList.append(buttonSelectView)
            initX += width + spaceX
            i += 1
            
        }
        widthGeneralView.constant = initX
        selectIndex(index: indexDefault)
    }
    
    private func selectIndex(index: Int){
        dateButtonsList.forEach { buttonSelectView in
            buttonSelectView.state = index == buttonSelectView.tag
        }
    }
}
