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
    
    private var _color:    UIColor
    private var _animated: Bool
    private var _sound:    Bool
    private var _volume:   Float
    
    private init() {
        _color    = Design.Default.appearance.color
        _animated = Design.Default.appearance.animated
        _sound    = Design.Default.appearance.sound
        _volume   = Design.Default.appearance.volume
    }
    
    internal var subscribers: [WeakSubscriber] = []
}


extension Appearance: AppearanceStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case color     = "EmojiMatching.Storage.Appearance.Color"
        case animation = "EmojiMatching.Storage.Appearance.Animation"
        case sound     = "EmojiMatching.Storage.Appearance.Sound"
        case volume    = "EmojiMatching.Storage.Appearance.Volume"
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
    
    var sound: Bool {
        get {
            _sound
        }
        set {
            guard newValue != _sound else { return }
            _sound = newValue
            notify()
            let key = UserDefaultsKeys.sound
            defaults.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    var volume: Float {
        get {
            _volume
        }
        set {
            guard newValue != _volume, (0.0 ... 1.0).contains(newValue) else { return }
            _volume = newValue
            notify()
            let key = UserDefaultsKeys.volume
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
            case .animation:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _animated = saved
                    print("\t✅ Animation: \(_animated)")
                }
            case .sound:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _sound = saved
                    print("\t✅ Sound: \(_sound)")
                }
            case .volume:
                if let saved = defaults.value(forKey: key.rawValue) as? Float, (0.0 ... 1.0).contains(saved) {
                    _volume = saved
                    print("\t✅ Volume: \(_volume)")
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
        _animated = Design.Default.appearance.animated
        _sound    = Design.Default.appearance.sound
        _volume   = Design.Default.appearance.volume
        
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
