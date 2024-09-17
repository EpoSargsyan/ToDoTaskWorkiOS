//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 15.09.24.
//

import UIKit
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()

    private init() { }
}
