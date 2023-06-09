//
//  String+Extension.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
extension String {
    var htmlToAttributedString: NSAttributedString? {
        let modifiedFont = NSString(format:"<span style=\"font-size: 17; color: white\">%@</span>", self) as String
        guard let data = modifiedFont.data(using: .utf8) else { return nil }
        do {
            
            //let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 14) ]
            let atributes = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding:String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any]
            return try NSAttributedString(data: data, options: atributes, documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
