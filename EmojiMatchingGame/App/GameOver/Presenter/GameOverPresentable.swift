//
//  GameOverPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol GameOverPresentable {
    
    var animated: Bool { get }
    
    init(
        _ viewController: GameOverDisplayable,
         router:          GameOverRoutable,
         audio:           Audible,
         animated:        Bool,
         time:            TimeInterval?,
         taps:            UInt,
         isBest:          Bool,
         isFinalLevel:    Bool
    )
    
    func viewWillAppear()
    
    func next()
    func replay()
    
    func soundGenerationToFireworks()
}
