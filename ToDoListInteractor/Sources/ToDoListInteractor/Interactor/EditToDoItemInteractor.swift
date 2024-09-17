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
import CoreData

public protocol IEditToDoItemInteractor {
    var todo: ToDoItemCoreData { get }
    func saveChanges(context: NSManagedObjectContext)
}

public class EditToDoItemInteractor: BaseInteractor, IEditToDoItemInteractor {

    private let coreDataService: ICoreDataService
    private let editToDoItemService: IEditToDoItemService

    public var todo: ToDoItemCoreData

    public init(editToDoItemService: IEditToDoItemService,
                navigationModel: EditToDoItemNavigatioModel,
                coreDataService: ICoreDataService) {
        self.editToDoItemService = editToDoItemService
        self.todo = navigationModel.todo
        self.coreDataService = coreDataService
    }

    @MainActor
    public func saveChanges(context: NSManagedObjectContext) {
        do {
            try coreDataService.saveChanges(context: context)
        } catch {
            errorEvent.send(error)
        }
    }
}
