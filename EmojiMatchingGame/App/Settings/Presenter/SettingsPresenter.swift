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
    
    init(_ viewController: SettingsDisplayable, appearance: AppearanceStorageable) {
        self.viewController = viewController
        self.appearance = appearance
        self.appearance.register(self)
        print("PRESENTER:\t😈\tSettings")
    }
    
    deinit {
        appearance.unsubscribe(self)
        print("PRESENTER:\t♻️\tSettings")
    }
    
    private func display() {
        viewController?.displayColor(appearance.color)
        viewController?.displayAnimation(appearance.animated)
        viewController?.displayHaptics(appearance.isSupportsHaptics ? appearance.haptics : false)
        viewController?.displayHapticsSupports(appearance.isSupportsHaptics)
    }
    
    func fetch() {
        appearance.fetch()
        display()
    }
    
    func update(color: UIColor) {
        appearance.color = color
    }
    
    func update(isAnimation: Bool) {
        appearance.animated = isAnimation
    }
    
    func update(isHaptics: Bool) {
        appearance.haptics = isHaptics
    }
    
    func reset() {
        appearance.clear()
    }
}


extension SettingsPresenter: Subscriber {
    
    func update() {
        display()
    }
}
