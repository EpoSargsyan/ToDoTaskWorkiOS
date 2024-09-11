//
//  ApiError.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

public struct ApiError: Error {

    var statusCode: Int
    var message: String

    init(statusCode: Int = 0, message: String) {
        self.statusCode = statusCode
        self.message = message
    }

    private enum CodingKeys: String, CodingKey {
        case statusCode
        case message
    }
}

extension ApiError: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        message = try container.decode(String.self, forKey: .message)
    }
}
