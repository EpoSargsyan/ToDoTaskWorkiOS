//
//  StackView.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import UIKit

public extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)

        self.axis = axis
        self.spacing = spacing
        self.isUserInteractionEnabled = true
    }
}
