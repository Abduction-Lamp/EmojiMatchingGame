//
//  SettingsViewSetupable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 27.11.2023.
//

import UIKit

protocol SettingsViewSetupable: AnyObject where Self: UIView {
    
    var delegate: SettingsViewDelegate? { get set }
    
    func setupColor(_ color: UIColor) -> Bool
    func setupAnimation(_ isAnimation: Bool) -> Bool
    func setupHaptic(_ isHaptic: Bool) -> Bool
    func setupHapticEnabled(_ isEnabled: Bool) -> Bool
    func setupSoundVolume(_ value: Float) -> Bool
}

protocol SettingsViewDelegate: AnyObject {
    
    func colorButtonTapped(_ sender: UIButton)
    func animationToggleSwitched(_ isOn: Bool)
    func hapticToggleSwitched(_ isOn: Bool)
    func resetTapped()
}
