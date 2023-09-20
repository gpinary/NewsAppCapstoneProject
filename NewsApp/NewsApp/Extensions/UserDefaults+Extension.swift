//
//  UserDefaults+Extension.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    var hasOnboarded:Bool {
        get{
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue,forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
