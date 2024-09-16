//
//  ToDoItemPresentationModel.swift
//
//
//  Created by Eprem Sargsyan on 12.09.24.
//

import Foundation

public struct ToDoItemPresentationModel {
    public let todoModel: ToDoItemCoreData

    public init(todoModel: ToDoItemCoreData) {
        self.todoModel = todoModel
    }
}
