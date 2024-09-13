//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import UIKit
import ToDoListInteractor
import ToDoListEntity

final class ToDoListRouter {
    static func showToDoListViewController(in navigationController: UINavigationController) {
        let viewController = Presenter.presentToDoListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showNewTaskViewController(in navigationController: UINavigationController) {
        let viewController = Presenter.presentNewTaskViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
