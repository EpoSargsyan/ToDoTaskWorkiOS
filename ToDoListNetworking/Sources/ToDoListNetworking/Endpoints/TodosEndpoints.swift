//
//  TodosEndpoints.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

public enum TodosEndpoints: IEndpointProvider {
    case getTodos

    public var path: String {
        return "/todos"
    }

    public var method: RequestMethod {
        return .get
    }

    public var queryItems: [URLQueryItem]? {
        return nil
    }

    public var body: [String : Any]? {
        return nil
    }
}
