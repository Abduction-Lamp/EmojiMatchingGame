//
//  PlayBoardViewDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.11.2023.
//

import UIKit

protocol PlayBoardViewDisplayable {
    
    func setupLevelMenu(unlock: Indexable)
    func selectLevelMenu(level: Indexable)
    
    func playNewGame(level: Sizeable, with cards: [CardView], animated: Bool)
}

extension PlayBoardViewDisplayable where Self: UIView {}
