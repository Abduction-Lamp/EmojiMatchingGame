//
//  PlayBoardPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol PlayBoardPresentable: AnyObject {
    
    init(_ viewController: PlayBoardDisplayable, router: PlayBoardRoutable, level: Level, emoji: Emoji)
    
    func play()
    func nextLevel()
    func flip(index: Int)
    
    func goBackMainMenu()
}
