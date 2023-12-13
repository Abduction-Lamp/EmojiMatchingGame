//
//  User.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 19.10.2023.
//

import Foundation

final class User {
    
    struct BestResult: Codable, Comparable {
        let time: TimeInterval
        let taps: UInt
        
        static func < (lhs: User.BestResult, rhs: User.BestResult) -> Bool {
            if (lhs.time < rhs.time) { return true }
            if (lhs.time == rhs.time) && (lhs.taps < rhs.taps) { return true }
            return false
        }
    }
    
    static let shared = User()
    
    private let defaults = UserDefaults.standard

    private var _unlockLevel: Levelable
    private var _startLevel:  Levelable
    private var _bestResults: [String: BestResult]
    
    private init() {
        _unlockLevel = Level.one
        _startLevel  = Level.one
        _bestResults = [:]
    }
}


extension User: UserStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case unlockLevel = "EmojiMatching.Storage.User.UnlockLevel"
        case startLevel  = "EmojiMatching.Storage.User.StartLevel"
        case bestResults = "EmojiMatching.Storage.User.BestResults"
    }
    
    var unlockLevel: any Levelable {
        get {
            _unlockLevel
//            Level.six
        }
        set {
            if newValue.index > _unlockLevel.index {
                let key = UserDefaultsKeys.unlockLevel.rawValue
                _unlockLevel = newValue
                defaults.setValue(newValue.index, forKey: key)
            }
        }
    }

    var startLevel: Levelable {
        get {
            _startLevel
        }
        set {
            if newValue.index <= _unlockLevel.index, newValue.index != _startLevel.index {
                let key = UserDefaultsKeys.startLevel.rawValue
                _startLevel = newValue
                defaults.setValue(newValue.index, forKey: key)
            }
        }
    }

    var bestResults: [String: BestResult] {
        _bestResults
    }

    func getBestResult(for level: Levelable) -> BestResult? {
        _bestResults[level.description]
    }
    
    func setBestResult(for level: Levelable, result: BestResult) {
        if let best = _bestResults[level.description], best < result { return }
        _bestResults[level.description] = result
        
        switch archive(_bestResults) {
        case let .success(data):
            let key = UserDefaultsKeys.bestResults.rawValue
            defaults.set(data, forKey: key)
        case let .failure(error):
            print("⚠️ Error save best results: \(error.localizedDescription)")
        }
    }
    
    func fetch() {
        print("USER\t\t🤗\tFetch > Start")
        UserDefaultsKeys.allCases.forEach { key in
            switch key {
            case .unlockLevel:
                if let level = defaults.value(forKey: key.rawValue) as? Int {
                    _unlockLevel = Level(rawValue: level) ?? _unlockLevel
                    print("\t✅ Unlock Level: \(_unlockLevel)")
                }
            case .startLevel:
                if let level = defaults.value(forKey: key.rawValue) as? Int, level <= _unlockLevel.index {
                    _startLevel = Level(rawValue: level) ?? _startLevel
                    print("\t✅ Start Level: \(_startLevel)")
                }
            case .bestResults:
                if let results = defaults.value(forKey: key.rawValue) as? Data {
                    switch unarchive(results) {
                    case let .success(best):
                        _bestResults = best
                        print("\t✅ Best Results for \(_bestResults.count) level(s)")
                    case let .failure(error):
                        print("⚠️ Error load best results: \(error.localizedDescription)")
                    }
                }
            }
        }
        print("USER\t\t🤗\tFetch > Stop")
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
        _bestResults = [:]
    }
}


extension User {
    
    private func archive(_ property: [String : BestResult]) -> Result<Data, Error> {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(property)
            let key = UserDefaultsKeys.bestResults.rawValue
            defaults.setValue(data, forKey: key)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    private func unarchive(_ data: Data) -> Result<[String: BestResult], Error> {
        let decoder = PropertyListDecoder()
        do {
            let results = try decoder.decode([String: BestResult].self, from: data)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}
