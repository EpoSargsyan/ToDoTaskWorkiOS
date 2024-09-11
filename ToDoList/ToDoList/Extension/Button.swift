//
//  Button.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 10.09.24.
//

import UIKit.UIButton

public extension UIButton {
    convenience init(backgroundColor: UIColor,
                     title: String,
                     textColor: UIColor,
                     image: String? = nil) {
        self.init()

        self.layer.cornerRadius = 16
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.setTitle(title, for: .normal)

        if let image {
            self.setImage(UIImage(systemName: image), for: .normal)
        }
    }
}
