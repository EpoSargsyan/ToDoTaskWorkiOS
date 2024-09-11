//
//  Encodable.swift
//
//
//  Created by Eprem Sargsyan on 11.09.24.
//

import Foundation

extension Encodable {

    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
