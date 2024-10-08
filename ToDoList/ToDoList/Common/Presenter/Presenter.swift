//
//  Presenter.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation
import Swinject
import ToDoListInteractor
import ToDoListEntity

final class Presenter {
    static func presentToDoListViewController() -> ToDoListViewController {
        let assembler = Assembler([ToDoListAssembly()])
        let viewController = ToDoListViewController()
        viewController.interactor = assembler.resolver.resolve(IToDoInteractor.self)
        return viewController
    }

    static func presentNewTaskViewController() -> NewTaskViewController {
        let assembler = Assembler([ToDoListAssembly()])
        let viewController = NewTaskViewController()
        viewController.interactor = assembler.resolver.resolve(INewTaskInteractor.self)
        return viewController
    }

    static func presentEditToDoItemViewController(navigationModel: EditToDoItemNavigatioModel) -> EditToDoItemViewController {
        let assembler = Assembler([ToDoListAssembly()])
        let viewController = EditToDoItemViewController()
        viewController.interactor = assembler.resolver.resolve(IEditToDoItemInteractor.self,
                                                               argument: navigationModel)
        return viewController
    }
}
