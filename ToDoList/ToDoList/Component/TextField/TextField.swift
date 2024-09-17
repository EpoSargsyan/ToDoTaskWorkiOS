//
//  TextField.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 17.09.24.
//

import UIKit

public class TextField: UITextField {
    var eyeConfiguration: Bool = false

    public convenience init(placeholder: String) {

        self.init()
        self.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.cornerRadius = 16
        self.backgroundColor = .systemGray4
        self.textColor = .black
        self.keyboardType = .default

        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 14, dy: 0)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 14, dy: 0)
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 14, dy: 0)
    }
}
