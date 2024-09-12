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

public protocol IToDoInteractor {
    var todosSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func getTodos() async
}

public class ToDoInteractor: IToDoInteractor {

    private let toDoService: IToDoService
    private let apiClient: IApiCient

    public var todosSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(toDoService: IToDoService,
                apiClient: IApiCient) {
        self.toDoService = toDoService
        self.apiClient = apiClient
    }

    @MainActor
    public func getTodos() async {
        let endpoint = TodosEndpoints.getTodos

        do {
            let result = try await apiClient.asyncRequest(endpoint: endpoint,
                                                          responseModel: ToDoResponseModel.self)
            todosSuccessSubject.send(true)
        } catch {
            
        }
    }

//    let endpoint = StoryEndpoints.getAllStories
//    do {
//        _ = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: StoriesResponseModel.self)
//        isLoading.send(false)
//        allStoriesSuccessSubject.send(true)
//    } catch {
//        errorEvent.send(error)
//        isLoading.send(false)
//    }
}
