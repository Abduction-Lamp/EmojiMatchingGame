//
//  PlayBoardPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.07.2023.
//

import Foundation


protocol PlayBoardPresentable: AnyObject {
    
    var viewController: PlayBoardDisplayable? { get }
    
    func play()
}


final class PlayBoardPresenter: PlayBoardPresentable  {
    
    private var level: Level
    private var cards: [String] = []
    
    weak var viewController: PlayBoardDisplayable?
    
    init(_ vc: PlayBoardDisplayable, level: Level = .two) {
        self.viewController = vc
        self.level = level
    }
 
    
    func play() {
        level = level.next()
    
        let emoji = Emoji()
        cards = emoji.makeSequence(for: level)
        
        viewController?.play(level: level, with: cards)
    }
}
