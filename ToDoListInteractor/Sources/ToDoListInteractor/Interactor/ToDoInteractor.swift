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
    var todosDB: [ToDoItemCoreData] { get set }
    var completedTodos: [ToDoItemCoreData] { get }
    var notCompletedTodos: [ToDoItemCoreData] { get }
    var todosSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var updateCompletedSubject: PassthroughSubject<(UUID, Bool), Never> { get }

    func getTodos(context: NSManagedObjectContext) async
    func loadTodosfromDB(context: NSManagedObjectContext)
    func delteTodoDB(context: NSManagedObjectContext, item: ToDoItemCoreData)
    func saveChanges(context: NSManagedObjectContext)
}

public class ToDoInteractor: BaseInteractor, IToDoInteractor {
    private let toDoService: IToDoService
    private let apiClient: IApiClient
    private let coreDataService: ICoreDataService
    private let appStorageService: IAppStorageService

    public var todosDB: [ToDoItemCoreData] = []
    public var completedTodos: [ToDoItemCoreData] = []
    public var notCompletedTodos: [ToDoItemCoreData] = []
    public var todosSuccessSubject = PassthroughSubject<Bool, Never>()
    public var updateCompletedSubject = PassthroughSubject<(UUID, Bool), Never>()

    public init(toDoService: IToDoService,
                coreDataService: ICoreDataService,
                apiClient: IApiClient,
                appStorageService: IAppStorageService) {
        self.toDoService = toDoService
        self.coreDataService = coreDataService
        self.apiClient = apiClient
        self.appStorageService = appStorageService
    }

    @MainActor
    public func getTodos(context: NSManagedObjectContext) async {
        let endpoint = TodosEndpoints.getTodos

        do {
            let result = try await apiClient.asyncRequest(endpoint: endpoint,
                                                          responseModel: ToDoResponseModel.self)

            if (appStorageService.getData(key: .dataLoaded) ?? true) {
                for i in 0..<result.todos.count {
                    let item = ToDoItemCoreData(context: context)
                    item.todo = result.todos[i].todo
                    item.team = "Team"
                    item.startingDate = "Today 12:00"
                    item.endingDate = "Today 13:00"
                    item.completed = result.todos[i].completed
                    item.userID = Int64(result.todos[i].userId)
                    item.id = UUID()
                    todosDB.append(item)
                    do {
                        try context.save()
                    } catch {
                        errorEvent.send(error)
                    }
                }
            }

            appStorageService.saveData(key: .dataLoaded, value: false)

            todosSuccessSubject.send(true)
        } catch {
            errorEvent.send(error)
        }
    }

    @MainActor
    public func loadTodosfromDB(context: NSManagedObjectContext) {
        do  {
            todosDB = try coreDataService.getAllItems(context: context).reversed()
            completedTodos = todosDB.filter { $0.completed }
            notCompletedTodos = todosDB.filter { !$0.completed }
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
        } catch {
            errorEvent.send(error)
        }
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
