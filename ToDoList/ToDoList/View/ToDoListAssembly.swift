//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import ToDoListInteractor
import ToDoListNetworking
import ToDoListEntity

final class ToDoListAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IToDoInteractor.self, initializer: ToDoInteractor.init)
        container.autoregister(IEditToDoItemInteractor.self,
                               argument: EditToDoItemNavigatioModel.self,
                               initializer: EditToDoItemInteractor.init)
        container.autoregister(INewTaskInteractor.self, initializer: NewTaskInteractor.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IToDoService.self, initializer: ToDoService.init)
        container.autoregister(IEditToDoItemService.self, initializer: EditToDoItemService.init)
        container.autoregister(ICoreDataService.self, initializer: CoreDataService.init)
        container.autoregister(IApiClient.self, initializer: ApiClient.init)
        container.autoregister(IAppStorageService.self, initializer: AppStorageService.init)
    }
}
