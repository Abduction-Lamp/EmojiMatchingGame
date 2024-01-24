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

    func play(level: Sizeable, with cards: [CardView], animated: Bool)
    func clean(animated: Bool, completion: (() -> Void)?)
}

extension PlayBoardViewDisplayable where Self: UIView { }


protocol PlayBoardViewDisplayableDetails {
    
    func shiftLevelMenu()
    func hiddenLevelMenu()
    func showLevelMenu()
    
    func hiddenButtons()
    func showButtons()
    
    func hiddenBoard()
    func showBoard()
}
