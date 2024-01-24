//
//  SettingsDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit

protocol SettingsDisplayable: AnyObject {
    
    var presenter: SettingsPresentable? { get set }
    
    func displayColor(_ color: UIColor)
    func displayAnimation(_ isAnimation: Bool)
    func displaySoundVolume(_ isOn: Bool, volume: Float)
}
