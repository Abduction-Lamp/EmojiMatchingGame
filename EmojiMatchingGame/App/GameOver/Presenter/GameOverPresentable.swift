//
//  GameOverPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol GameOverPresentable {
    
    init(_ viewController: GameOverDisplayable, router: GameOverRoutable)
    
    func nextLevel()
    func repeatLevel()
}
