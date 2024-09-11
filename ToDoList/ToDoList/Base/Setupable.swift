//
//  Setupable.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
