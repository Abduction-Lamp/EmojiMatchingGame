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
    
    func setupSoundVolumeButton(volume: Float)
    
    func play(level: Sizeable, with cards: [CardView], animated: Bool)
    func clean(animated: Bool, completion: (() -> Void)?)
    
    // Действия при переходе (Will Transition)
    func hiddenLevelMenu()
    func showLevelMenu()
    func shiftLevelMenu()
    
    func hiddenButtons()
    func showButtons()
    
    func hiddenBoard()
    func showBoard()
}

extension PlayBoardViewDisplayable where Self: UIView { }
