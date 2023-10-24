//
//  Appearance.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 09.10.2023.
//

import UIKit

final class Appearance {
    
    static let shared = Appearance()
    
    private let defaults = UserDefaults.standard
    
    private var _color:     UIColor
    private var _haptics:   Bool
    private var _animated: Bool
    
    private init() {
        _color     = .systemYellow
        _haptics   = true
        _animated = false
    }
}


extension Appearance: AppearanceStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case color     = "Appearance.Color"
        case haptics   = "Appearance.Haptics"
        case animation = "Appearance.Animation"
    }
    
    
    var color: UIColor {
        get {
            _color
        }
        set {
            let key = UserDefaultsKeys.color
            _color = newValue
            defaults.setValue(newValue.hex, forKey: key.rawValue)
        }
    }
    
    var haptics: Bool {
        get {
            _haptics
        }
        set {
            let key = UserDefaultsKeys.haptics
            _haptics = newValue
            defaults.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    var animated: Bool {
        get {
            _animated
        }
        set {
            let key = UserDefaultsKeys.animation
            _animated = newValue
            defaults.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    
    func fetch() {
        print("APPEARANCE:\t🐒 Fetch > Start")
        UserDefaultsKeys.allCases.forEach { key in
            switch key {
            case .color:
                if let hex = defaults.value(forKey: key.rawValue) as? String,
                   let savedColor = UIColor(hex: hex) {
                    _color = savedColor
                    print("\t✅ Color: hex > \(hex), rgba > \(_color)")
                }
            case .haptics:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _haptics = saved
                    print("\t✅ Haptics: \(_haptics)")
                }
            case .animation:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _animated = saved
                    print("\t✅ Animation: \(_animated)")
                }
            }
        }
        print("APPEARANCE:\t🙈 Fetch > Stop")
    }
}
