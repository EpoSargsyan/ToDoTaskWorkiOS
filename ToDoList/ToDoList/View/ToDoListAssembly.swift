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

final class ToDoListAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IToDoInteractor.self, initializer: ToDoInteractor.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IToDoService.self, initializer: ToDoService.init)
        container.autoregister(IApiClient.self, initializer: ApiClient.init)
    }
}
