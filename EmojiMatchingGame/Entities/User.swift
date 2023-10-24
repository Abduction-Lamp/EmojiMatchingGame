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

    private var _unlockLevel: Level
    private var _startLevel:  Level
    private var _bestTime:    [Level: TimeInterval]
    
    private init() {
        _unlockLevel = .one
        _startLevel  = .one
        _bestTime    = [:]
    }
}


extension User: UserStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case unlockLevel = "User.UnlockLevel"
        case startLevel  = "User.StartLevel"
        case bestTime    = "User.BestTime"
    }
    
    var unlockLevel: Level {
        get {
            _unlockLevel
        }
        set {
            if newValue.rawValue > _unlockLevel.rawValue {
                let key = UserDefaultsKeys.unlockLevel
                _unlockLevel = newValue
                defaults.setValue(newValue.rawValue, forKey: key.rawValue)
            }
        }
    }

    var startLevel: Level {
        get {
            _startLevel
        }
        set {
            if newValue.rawValue <= _unlockLevel.rawValue,
               newValue.rawValue != _startLevel.rawValue {
                let key = UserDefaultsKeys.startLevel
                _startLevel = newValue
                defaults.setValue(newValue.rawValue, forKey: key.rawValue)
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
                    print("\t✅ Unlock Level: \(_unlockLevel) (\(_unlockLevel.rawValue))")
                }
            case .startLevel:
                if let level = defaults.value(forKey: key.rawValue) as? Int,
                   level <= _unlockLevel.rawValue {
                    _startLevel = Level(rawValue: level) ?? _startLevel
                    print("\t✅ Start Level: \(_startLevel)")
                }
            case .bestTime: break
                
            }
        }
        print("USER:\t\t🙈 Fetch > Stop")
    }
    
    func nextLevel() {
        unlockLevel = unlockLevel.next()
    }
}
