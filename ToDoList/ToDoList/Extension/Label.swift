//
//  UILabel.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 10.09.24.
//

import UIKit

public extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont?) {
        self.init()

        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = .left
    }

    func strikeThroughText() {
        let attributeString =  NSMutableAttributedString(string: self.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        self.attributedText = attributeString
    }

    func removeStrikethroughText() {
        guard let text = self.text else { return }
        let attributeString = NSMutableAttributedString(string: text)

        let fullRange = NSRange(location: 0, length: attributeString.length)

        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: fullRange)

        self.attributedText = attributeString
    }
}
