//
//  MainMenuPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol MainMenuPresentable: AnyObject {
    
    init(_ viewController: MainMenuDisplayable, router: MainMenuRoutable)

    func newGame()
    func settings()
    func statistics()
}
