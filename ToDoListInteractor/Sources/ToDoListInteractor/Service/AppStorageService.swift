//
//  File.swift
//  
//
//  Created by Eprem Sargsyan on 16.09.24.
//

import Foundation

public protocol IAppStorageService {
    func saveData<T>(key: StorageKeys, value: T)
    func getData<T>(key: StorageKeys) -> T?
    func deleteData(key: StorageKeys)
}

public final class AppStorageService: IAppStorageService {

    private let userDefaults = UserDefaults.standard

    public init() { }

    public func saveData<T>(key: StorageKeys, value: T) {
        userDefaults.setValue(value, forKey: key.rawValue)
        userDefaults.synchronize()
    }

    public func getData<T>(key: StorageKeys) -> T? {
        return userDefaults.value(forKey: key.rawValue) as? T
    }

    public func deleteData(key: StorageKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
        userDefaults.synchronize()
    }
}

public enum StorageKeys: String {
    case dataLoaded = "dataLoaded"
}
