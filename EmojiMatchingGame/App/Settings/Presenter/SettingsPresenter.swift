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
        
        print("PRESENTER:\t😈\tSettings")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tSettings")
    }
    
    
    func fetch() {
        appearance.fetch()
        
        viewController?.displayColor(appearance.color)
        viewController?.displayAnimation(appearance.animated)
        viewController?.displayHaptics(appearance.isSupportsHaptics ? appearance.haptics : false)
        viewController?.displayHapticsSupports(appearance.isSupportsHaptics)
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
}
