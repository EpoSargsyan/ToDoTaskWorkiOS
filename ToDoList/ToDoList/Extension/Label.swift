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
}
