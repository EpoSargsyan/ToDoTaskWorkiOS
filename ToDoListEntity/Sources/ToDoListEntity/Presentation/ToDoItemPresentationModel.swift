//
//  ToDoItemPresentationModel.swift
//
//
//  Created by Eprem Sargsyan on 12.09.24.
//

import Foundation

public struct ToDoItemPresentationModel {
    public let todo: String
    public let completed: Bool

    public init(todo: String, completed: Bool) {
        self.todo = todo
        self.completed = completed
    }
}
