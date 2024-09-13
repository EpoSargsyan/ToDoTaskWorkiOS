//
//  EditToDoItemInteractor.swift
//
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import Foundation
import Combine
import ToDoListEntity
import ToDoListNetworking

public protocol IEditToDoItemInteractor {
    var title: String { get }
    var description: String { get }
    var startingDate: String { get }
    var endingDate: String { get }
}

public class EditToDoItemInteractor: IEditToDoItemInteractor {

    private let editToDoItemService: IEditToDoItemService

    public var title: String = ""
    public var description: String = ""
    public var startingDate: String = ""
    public var endingDate: String = ""

    public init(editToDoItemService: IEditToDoItemService,
                navigationModel: EditToDoItemNavigatioModel) {
        self.editToDoItemService = editToDoItemService
        self.title = navigationModel.title
        self.description = navigationModel.description
        self.startingDate = navigationModel.startingDate
        self.endingDate = navigationModel.endingDate
    }
}
