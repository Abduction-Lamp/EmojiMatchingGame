//
//  SettingsPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit

final class SettingsPresenter: SettingsPresentable {
    
    private weak var viewController: SettingsDisplayable?
    private let appearance: AppearanceStorageable
    private weak var audio: Audible?
    
    init(_ viewController: SettingsDisplayable, appearance: AppearanceStorageable, audio: Audible) {
        self.viewController = viewController
        self.audio = audio
        self.appearance = appearance
        self.appearance.register(self)
    }
    
    deinit {
        appearance.unsubscribe(self)
    }
    
    private func display() {
        var mode = -1
        switch appearance.mode {
        case .light:       mode =  0
        case .dark:        mode =  1
        case .unspecified: mode =  2
        @unknown default:  mode = -1
        }
        
        viewController?.displayTheme(mode)
        viewController?.displayColor(appearance.color)
        viewController?.displayAnimation(appearance.animated)
        viewController?.displaySoundVolume(appearance.sound, volume: appearance.volume)
    }
    
    func fetch() {
        appearance.fetch()
        display()
    }
    
    func update(mode: Int) {
        if appearance.sound {
            audio?.play(.flip1)
        }
        switch mode {
        case 0: appearance.mode = .light
        case 1: appearance.mode = .dark
        case 2: appearance.mode = .unspecified
        default: return
        }
    }
    
    func update(color: UIColor) {
        appearance.color = color
    }
    
    func update(isAnimation: Bool) {
        appearance.animated = isAnimation
    }
    
    func update(isSoundOn: Bool) {
        appearance.sound = isSoundOn
        if isSoundOn {
            audio?.play(.menu2)
        }
    }
    
    func update(volume: Float) {
        appearance.volume = volume
        audio?.play(.menu2)
    }
    
    func reset() {
        appearance.clear()
    }
    
    func soundGenerationToDismiss() {
        if appearance.sound {
            audio?.play(.flip1)
        }
    }
    
    func soundGenerationToViewWillAppear() {
        if appearance.sound {
            audio?.play(.flip1)
        }
    }
}


extension SettingsPresenter: Subscriber {
    
    func update() {
        display()
    }
}
