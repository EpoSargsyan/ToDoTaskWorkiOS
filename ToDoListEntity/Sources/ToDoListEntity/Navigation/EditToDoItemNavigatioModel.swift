//
//  EditToDoItemNavigatioModel.swift
//
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import Foundation

public struct EditToDoItemNavigatioModel {
    public let title: String
    public let description: String
    public let startingDate: String
    public let endingDate: String

    public init(title: String, description: String, startingDate: String, endingDate: String) {
        self.title = title
        self.description = description
        self.startingDate = startingDate
        self.endingDate = endingDate
    }
}
