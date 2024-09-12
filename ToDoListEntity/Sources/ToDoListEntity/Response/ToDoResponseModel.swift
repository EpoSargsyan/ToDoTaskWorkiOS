//
//  ToDoResponseModel.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

// MARK: - Welcome
public struct ToDoResponseModel: Codable {
    public let todos: [TodoDetails]
    public let total: Int
    public let skip: Int
    public let limit: Int
}

// MARK: - Todo
public struct TodoDetails: Codable {
    public let id: Int
    public let todo: String
    public let completed: Bool
    public let userId: Int
}
