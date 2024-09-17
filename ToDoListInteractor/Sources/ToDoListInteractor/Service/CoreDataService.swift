//
//  File.swift
//  
//
//  Created by Eprem Sargsyan on 14.09.24.
//

import Foundation
import ToDoListEntity
import CoreData

public protocol ICoreDataService {
    func getAllItems(context: NSManagedObjectContext) throws -> [ToDoItemCoreData]
    func saveChanges(context: NSManagedObjectContext) throws
    func deleteItem(context: NSManagedObjectContext, item: ToDoItemCoreData) throws
}

public final class CoreDataService: ICoreDataService {

    public init() {}

    public func getAllItems(context: NSManagedObjectContext) throws -> [ToDoItemCoreData] {
        return try context.fetch(ToDoItemCoreData.fetchRequest())
    }

    public func saveChanges(context: NSManagedObjectContext) throws {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    public func deleteItem(context: NSManagedObjectContext, item: ToDoItemCoreData) throws {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
