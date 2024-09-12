//
//  ToDoResponseModel.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

// MARK: - Welcome
public struct ToDoResponseModel: Codable {
    let todos: [TodoDetails]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - Todo
public struct TodoDetails: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
}
