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
    func flip(index: Int)
}


final class PlayBoardPresenter: PlayBoardPresentable  {
    
    private var level: Level
    private var cards: [String] = []
    
    weak var viewController: PlayBoardDisplayable?
    
    init(_ vc: PlayBoardDisplayable, level: Level = .one) {
        self.viewController = vc
        self.level = level
    }
 
    
    func play() {
        level = level.next()
        cards = Emoji().makeSequence(for: level)
        
        viewController?.play(level: level, with: cards)
    }
    
    func flip(index: Int) {
        viewController?.flip(index: index)
    
        check(index: index)
    }
    
    
    var upsideDownFirstIndex: Int? = nil
    var upsideDownSecondIndex: Int? = nil
    
    private func check(index: Int) {
        
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flip(index: first)
            viewController?.flip(index: second)
        }
        
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            return
        }
        
        upsideDownSecondIndex = index
        
        if first != index {
            if cards[first] == cards[index] {
                upsideDownFirstIndex = nil
                upsideDownSecondIndex = nil
                viewController?.disableCards(index: first, and: index)
            }
        } else {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
        }
    }
}
