//
//  GameOverDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol GameOverDisplayable: AnyObject { 
    
    var presenter: GameOverPresentable? { get set }
    
    func display(time: String, taps: String, isBest: Bool, isFinishMode: Bool)
}
