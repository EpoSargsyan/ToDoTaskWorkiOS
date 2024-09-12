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
    var result: ToDoResponseModel? { get }
    var todosSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var errorEvent: PassthroughSubject<Error, Never> { get }
    func getTodos() async
}

public class ToDoInteractor: IToDoInteractor {
    private let toDoService: IToDoService
    private let apiClient: IApiClient

    public var todosSuccessSubject = PassthroughSubject<Bool, Never>()
    public var errorEvent = PassthroughSubject<Error, Never>()
    public var result: ToDoResponseModel?

    public init(toDoService: IToDoService,
                apiClient: IApiClient) {
        self.toDoService = toDoService
        self.apiClient = apiClient
    }

    @MainActor
    public func getTodos() async {
        let endpoint = TodosEndpoints.getTodos

        do {
            result = try await apiClient.asyncRequest(endpoint: endpoint,
                                                          responseModel: ToDoResponseModel.self)
            todosSuccessSubject.send(true)
        } catch {
            errorEvent.send(error)
        }
    }
}
