//
//  ToDoItemsCountPresentationModel.swift
//
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import Foundation

public struct ToDoItemsCountPresentationModel {
    public let title: String
    public let count: Int

    public init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
