//
//  GameOverPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol GameOverPresentable {
    
    var doWithAnimation: Bool { get }
    
    init(_ viewController: GameOverDisplayable, router: GameOverRoutable, storage: Storage)
    
    func nextLevel()
    func repeatLevel()
}
