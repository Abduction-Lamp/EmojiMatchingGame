//
//  SettingsViewSetupable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 27.11.2023.
//

import UIKit

protocol SettingsViewSetupable: AnyObject where Self: UIView {
    
    var delegate: SettingsViewDelegate? { get set }
    
    func setupTheme(_ mode: Int) -> Bool
    func setupColor(_ color: UIColor) -> Bool
    func setupAnimation(_ isAnimation: Bool) -> Bool
    func setupSoundVolume(_ isOn: Bool, volume: Float) -> Bool
}

protocol SettingsViewDelegate: AnyObject {
    
    func themeChangedValue(_ mode: Int)
    func colorButtonTapped(_ sender: UIButton)
    func animationToggleSwitched(_ isOn: Bool)
    func soundToggleSwitched(_ isOn: Bool)
    func volumeSliderChanged(_ volume: Float)
    func resetTapped()
}
