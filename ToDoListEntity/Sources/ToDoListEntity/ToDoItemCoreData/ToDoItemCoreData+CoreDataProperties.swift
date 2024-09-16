//
//  ToDoItemCoreData+CoreDataProperties.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 14.09.24.
//
//

import Foundation
import CoreData


extension ToDoItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemCoreData> {
        return NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var startingDate: String?
    @NSManaged public var id: UUID?
    @NSManaged public var team: String?
    @NSManaged public var todo: String?
    @NSManaged public var endingDate: String?
    @NSManaged public var userID: Int64

}

extension ToDoItemCoreData : Identifiable {

}
