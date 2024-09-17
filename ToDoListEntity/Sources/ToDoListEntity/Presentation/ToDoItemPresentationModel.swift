//
//  ToDoItemPresentationModel.swift
//
//
//  Created by Eprem Sargsyan on 12.09.24.
//

import Foundation
import Combine

public struct ToDoItemPresentationModel {
    public let todoModel: ToDoItemCoreData
    public let updateCompletedSubject: PassthroughSubject<(UUID, Bool), Never>

    public init(todoModel: ToDoItemCoreData, updateCompletedSubject: PassthroughSubject<(UUID, Bool), Never>) {
        self.todoModel = todoModel
        self.updateCompletedSubject = updateCompletedSubject
    }
}
