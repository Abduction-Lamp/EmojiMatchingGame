//
//  Appearance.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 09.10.2023.
//

import UIKit
import CoreHaptics

final class Appearance {
    
    static let shared = Appearance()
    
    private let defaults = UserDefaults.standard
    
    private var _color:    UIColor
    private var _haptics:  Bool
    private var _animated: Bool
    
    private var _isSupportsHaptics: Bool
    
    private init() {
        _color    = Design.Default.appearance.color
        _haptics  = Design.Default.appearance.haptics
        _animated = Design.Default.appearance.animated
        
        let capabilities = CHHapticEngine.capabilitiesForHardware()
        _isSupportsHaptics = capabilities.supportsHaptics
    }
    
    internal var subscribers: [WeakSubscriber] = []
}


extension Appearance: AppearanceStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case color     = "EmojiMatching.Storage.Appearance.Color"
        case haptics   = "EmojiMatching.Storage.Appearance.Haptics"
        case animation = "EmojiMatching.Storage.Appearance.Animation"
    }
    
    
    var isSupportsHaptics: Bool {
        _isSupportsHaptics
    }
    
    var color: UIColor {
        get {
            _color
        }
        set {
            print(newValue)
            
            guard newValue != _color else { return }
            _color = newValue
            notify()
            let key = UserDefaultsKeys.color
            defaults.setValue(newValue.hex, forKey: key.rawValue)
        }
    }
    
    var haptics: Bool {
        get {
            _haptics
        }
        set {
            guard newValue != _haptics else { return }
            _haptics = newValue
            notify()
            let key = UserDefaultsKeys.haptics
            defaults.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    var animated: Bool {
        get {
            _animated
        }
        set {
            guard newValue != _animated else { return }
            _animated = newValue
            notify()
            let key = UserDefaultsKeys.animation
            defaults.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    
    func fetch() {
        print("APPEARANCE\t🎨\tFetch > Start")
        UserDefaultsKeys.allCases.forEach { key in
            switch key {
            case .color:
                if let hex = defaults.value(forKey: key.rawValue) as? String,
                   let saved = UIColor(hex: hex) {
                    _color = saved
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
        print("APPEARANCE\t🎨\tFetch > Stop")
    }
    
    func clear() {
        UserDefaultsKeys.allCases.forEach { key in
            defaults.setValue(nil, forKey: key.rawValue)
        }
        _color    = Design.Default.appearance.color
        _haptics  = Design.Default.appearance.haptics
        _animated = Design.Default.appearance.animated
        
        notify()
    }
}

extension Appearance {
    
    func register(_ subscriber: Subscriber) {
        if subscribers.contains(where: { $0.wrapped === subscriber }) { return }
        let wrapped = WeakSubscriber(subscriber)
        subscribers.append(wrapped)
    }
    
    func unsubscribe(_ subscriber: any Subscriber) {
        subscribers.removeAll(where: { $0.wrapped === subscriber })
    }
    
    func notify() {
        subscribers.forEach { $0.wrapped?.update() }
    }
}
