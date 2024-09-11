//
//  TableView.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: IReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: IReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: IReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: IReusableView {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue HeaderFooterView with identifier: \(T.reuseIdentifier)")
        }
        return headerFooterView
    }
}
