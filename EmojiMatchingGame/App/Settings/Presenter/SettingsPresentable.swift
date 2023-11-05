//
//  SettingsPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit

protocol SettingsPresentable: AnyObject {
    
    init(_ viewController: SettingsDisplayable, appearance: AppearanceStorageable)
    
    func fetch()
    func update(color: UIColor)
    func update(isAnimation: Bool)
    func update(isHaptics: Bool)
}
