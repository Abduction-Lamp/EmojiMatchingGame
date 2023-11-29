//
//  MainMenuSetupable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 28.11.2023.
//

import UIKit

protocol MainMenuSetupable: AnyObject {
    
    var newGameAction:    ((_: UIButton) -> Void)? { get set }
    var statisticsAction: ((_: UIButton) -> Void)? { get set }
    var settingsAction:   ((_: UIButton) -> Void)? { get set }
}
