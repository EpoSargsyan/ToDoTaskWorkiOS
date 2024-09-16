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
    func getAllItems(context: NSManagedObjectContext) async throws -> [ToDoItemCoreData]
    func setItem(context: NSManagedObjectContext, item: ToDoItemCoreData) async throws
    func deleteItem(context: NSManagedObjectContext, item: ToDoItemCoreData) throws
    func updateItem(context: NSManagedObjectContext, newItem: ToDoItemCoreData) async throws
}

public final class CoreDataService: ICoreDataService {

    public init() {}

    public func getAllItems(context: NSManagedObjectContext) async throws -> [ToDoItemCoreData] {
        return try context.fetch(ToDoItemCoreData.fetchRequest())
    }

    public func setItem(context: NSManagedObjectContext, item: ToDoItemCoreData) async throws {
        let newItem = ToDoItemCoreData(context: context)
        newItem.completed = item.completed
        newItem.todo = item.todo
        newItem.startingDate = item.startingDate
        newItem.endingDate = item.endingDate
        newItem.team = item.team
        newItem.userID = item.userID
        newItem.id = item.id
        try context.save()
    }

    public func deleteItem(context: NSManagedObjectContext, item: ToDoItemCoreData) throws {
        context.delete(item)
        try context.save()
    }

    public func updateItem(context: NSManagedObjectContext, newItem: ToDoItemCoreData) async throws {
        
    }
}
