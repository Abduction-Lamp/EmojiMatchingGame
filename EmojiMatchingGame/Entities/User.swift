//
//  User.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 19.10.2023.
//

import Foundation

final class User {
    
    static let shared = User()
    
    private let defaults = UserDefaults.standard

    private var _unlockLevel: Levelable
    private var _startLevel:  Levelable
    private var _bestTime:    [String: TimeInterval]
    
    private init() {
        _unlockLevel = Level.one
        _startLevel  = Level.one
        _bestTime    = [:]
    }
}


extension User: UserStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case unlockLevel = "EmojiMatching.Storage.User.UnlockLevel"
        case startLevel  = "EmojiMatching.Storage.User.StartLevel"
        case bestTime    = "EmojiMatching.Storage.User.BestTime"
    }
    
    var unlockLevel: Levelable {
        get {
            _unlockLevel
        }
        set {
            if newValue.index > _unlockLevel.index {
                let key = UserDefaultsKeys.unlockLevel
                _unlockLevel = newValue
                defaults.setValue(newValue.index, forKey: key.rawValue)
            }
        }
    }

    var startLevel: Levelable {
        get {
            _startLevel
        }
        set {
            if newValue.index <= _unlockLevel.index, newValue.index != _startLevel.index {
                let key = UserDefaultsKeys.startLevel
                _startLevel = newValue
                defaults.setValue(newValue.index, forKey: key.rawValue)
            }
        }
    }

//    var bestTime: [Level: TimeInterval] {
//        get {
//            _bestTime
//        }
//        set {
//
//        }
//    }
    
    
    func fetch() {
        print("USER:\t\t🐒 Fetch > Start")
        UserDefaultsKeys.allCases.forEach { key in
            switch key {
            case .unlockLevel:
                if let level = defaults.value(forKey: key.rawValue) as? Int {
                    _unlockLevel = Level(rawValue: level) ?? _unlockLevel
                    print("\t✅ Unlock Level: \(_unlockLevel))")
                }
            case .startLevel:
                if let level = defaults.value(forKey: key.rawValue) as? Int, level <= _unlockLevel.index {
                    _startLevel = Level(rawValue: level) ?? _startLevel
                    print("\t✅ Start Level: \(_startLevel)")
                }
            case .bestTime: break
                
            }
        }
        print("USER:\t\t🙈 Fetch > Stop")
    }

    func unlock() {
        unlockLevel = unlockLevel.next()
    }
    
    func clear() {
        UserDefaultsKeys.allCases.forEach { key in
            defaults.setValue(nil, forKey: key.rawValue)
        }
        _unlockLevel = Level.one
        _startLevel  = Level.one
        _bestTime    = [:]
    }
}
