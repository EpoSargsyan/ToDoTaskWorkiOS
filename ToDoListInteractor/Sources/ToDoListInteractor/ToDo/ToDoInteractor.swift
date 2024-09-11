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

}

public class ToDoInteractor: IToDoInteractor {
    
    private let toDoService: IToDoService

    public init(toDoService: IToDoService) {
        self.toDoService = toDoService
    }
}
