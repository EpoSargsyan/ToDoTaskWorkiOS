//
//  NewTaskInteractor.swift
//
//
//  Created by Eprem Sargsyan on 14.09.24.
//

import Foundation
import ToDoListEntity
import CoreData

public protocol INewTaskInteractor {
    func setTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData) async
}

public class NewTaskInteractor: BaseInteractor, INewTaskInteractor {

    private let coreDataService: ICoreDataService

    public init(coreDataService: ICoreDataService) {
        self.coreDataService = coreDataService
    }

    @MainActor
    public func setTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData) async {
        do {
            try await coreDataService.setItem(context: context, item: item)
        } catch {
            errorEvent.send(error)
        }
    }
}

