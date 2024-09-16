//
//  BaseInteractor.swift
//
//
//  Created by Eprem Sargsyan on 14.09.24.
//

import Foundation
import Combine

public class BaseInteractor {
    public var errorEvent = PassthroughSubject<Error, Never>()
}
