//
//  ToDoInteractor.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation
import Combine
import ToDoListEntity
import ToDoListNetworking
import CoreData

public protocol IToDoInteractor {
    var todosDB: [ToDoItemCoreData] { get }
    var completedTodos: [ToDoItemCoreData] { get }
    var notCompletedTodos: [ToDoItemCoreData] { get }
    var todosSuccessSubject: PassthroughSubject<Bool, Never> { get }

    func getTodos(context: NSManagedObjectContext) async
    func loadTodosfromDB(context: NSManagedObjectContext) async
    func setTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData) async
    func delteTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData)
}

public class ToDoInteractor: BaseInteractor, IToDoInteractor {
    private let toDoService: IToDoService
    private let apiClient: IApiClient
    private let coreDataService: ICoreDataService

    public var todosDB: [ToDoItemCoreData] = []
    public var completedTodos: [ToDoItemCoreData] = []
    public var notCompletedTodos: [ToDoItemCoreData] = []
    public var todosSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(toDoService: IToDoService,
                coreDataService: ICoreDataService,
                apiClient: IApiClient) {
        self.toDoService = toDoService
        self.coreDataService = coreDataService
        self.apiClient = apiClient
    }

    @MainActor
    public func getTodos(context: NSManagedObjectContext) async {
        let endpoint = TodosEndpoints.getTodos

        do {
            let result = try await apiClient.asyncRequest(endpoint: endpoint,
                                                          responseModel: ToDoResponseModel.self)

            todosDB.removeAll()

            for i in 0..<result.todos.count {
                let item = ToDoItemCoreData(context: context)
                item.todo = result.todos[i].todo
                item.completed = result.todos[i].completed
                item.userID = Int64(result.todos[i].userId)
                item.id = UUID()
//                try context.save()
            }

            todosSuccessSubject.send(true)
        } catch {
            errorEvent.send(error)
        }
    }

    @MainActor
    public func loadTodosfromDB(context: NSManagedObjectContext) async {
        do  {
            todosDB = try await coreDataService.getAllItems(context: context)
            completedTodos = todosDB.filter { $0.completed }
            notCompletedTodos = todosDB.filter { !$0.completed }
        } catch {
            errorEvent.send(error)
        }
    }

    @MainActor
    public func setTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData) async {
        do {
            try await coreDataService.setItem(context: context, item: item)
        } catch {
            errorEvent.send(error)
        }
    }

    @MainActor
    public func delteTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData) {
        do {
            try coreDataService.deleteItem(context: context, item: item)
            self.todosDB.removeAll { todo in
                todo == item
            }
            print("########## \(todosDB)")
        } catch {
            errorEvent.send(error)
        }
    }
}
