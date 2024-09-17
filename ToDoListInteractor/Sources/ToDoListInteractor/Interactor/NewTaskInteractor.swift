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
    func saveChanges(context: NSManagedObjectContext)
}

public class NewTaskInteractor: BaseInteractor, INewTaskInteractor {

    private let coreDataService: ICoreDataService

    public init(coreDataService: ICoreDataService) {
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
