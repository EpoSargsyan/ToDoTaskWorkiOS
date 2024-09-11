//
//  BaseViewController.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import UIKit
import Combine
import ToDoListInteractor

public protocol IInteractorableController {
    associatedtype Interactor

    var interactor: Interactor? { get }
}

class BaseViewController: UIViewController {
    internal var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }

    func setupUI() {

    }

    func setupInteractor() {
        
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        #endif
    }
}
