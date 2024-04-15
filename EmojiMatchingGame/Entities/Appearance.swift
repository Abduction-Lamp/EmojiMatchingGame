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
    
    private var _mode:     UIUserInterfaceStyle
    private var _color:    UIColor
    private var _animated: Bool
    private var _sound:    Bool
    private var _volume:   Float

    
    private init() {
        _mode     = Design.Default.appearance.mode
        _color    = Design.Default.appearance.color
        _animated = Design.Default.appearance.animated
        _sound    = Design.Default.appearance.sound
        _volume   = Design.Default.appearance.volume
    }
    
    internal var subscribers: [WeakSubscriber] = []
}


extension Appearance: AppearanceStorageable {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case mode      = "EmojiMatching.Storage.Appearance.Mode"
        case color     = "EmojiMatching.Storage.Appearance.Color"
        case animation = "EmojiMatching.Storage.Appearance.Animation"
        case sound     = "EmojiMatching.Storage.Appearance.Sound"
        case volume    = "EmojiMatching.Storage.Appearance.Volume"
    }
    
    
    var mode: UIUserInterfaceStyle {
        get {
            _mode
        }
        set {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let curentMode = windowScene.windows.first?.overrideUserInterfaceStyle,
                newValue != curentMode
            else { return }
            windowScene.windows.first?.overrideUserInterfaceStyle = newValue
            
            guard newValue != _mode else { return }
            _mode = newValue
            let key = UserDefaultsKeys.mode
            defaults.setValue(newValue.rawValue, forKey: key.rawValue)
        }
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
    
    func fetchOnlyMode() {
        if let raw = defaults.value(forKey: UserDefaultsKeys.mode.rawValue) as? UIUserInterfaceStyle.RawValue,
           let saved = UIUserInterfaceStyle(rawValue: raw) {
            _mode = saved
        }
    }
    
    func fetch() {
        UserDefaultsKeys.allCases.forEach { key in
            switch key {
            case .mode:
                fetchOnlyMode()
            case .color:
                if let hex = defaults.value(forKey: key.rawValue) as? String,
                   let saved = UIColor(hex: hex) {
                    _color = saved
                }
            case .animation:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _animated = saved
                }
            case .sound:
                if let saved = defaults.value(forKey: key.rawValue) as? Bool {
                    _sound = saved
                }
            case .volume:
                if let saved = defaults.value(forKey: key.rawValue) as? Float, (0.0 ... 1.0).contains(saved) {
                    _volume = saved
                }
            }
        }
    }
    
    func clear() {
        UserDefaultsKeys.allCases.forEach { key in
            defaults.setValue(nil, forKey: key.rawValue)
        }
        
        ///  Сохраняем в публичную переменную значение по умолчанию
        ///  Т.к. именно в сетторе (set) происходит вызов системной функции отвечающей за режим представления
        mode      = Design.Default.appearance.mode
        
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
