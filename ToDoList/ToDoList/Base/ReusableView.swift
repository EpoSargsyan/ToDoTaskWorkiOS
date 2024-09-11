//
//  ReusableView.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import UIKit

public protocol IReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension IReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
