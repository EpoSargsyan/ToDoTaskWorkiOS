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

    // MARK: - Onboarding
    static func makeViewController() -> ToDoListViewController {
//        let assembler = Assembler([OnboardingAssembly()])
        let viewController = ToDoListViewController()
//        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }
}
