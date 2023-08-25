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


final class PlayBoardPresenter {
    
    private var level: Level
    private var cards: [String] = []
    
    private var upsideDownFirstIndex: Int? = nil
    private var upsideDownSecondIndex: Int? = nil
    

    weak var viewController: PlayBoardDisplayable?
    
    
    init(_ vc: PlayBoardDisplayable, level: Level = .one) {
        self.viewController = vc
        self.level = level
    }
}


extension PlayBoardPresenter: PlayBoardPresentable {
    
    func play() {
        remove()
        level = level.next()
        cards = Emoji().makeSequence(for: level)
        viewController?.play(level: level, with: cards)
    }
    
    func flip(index: Int) {
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flipCard(index: first, completion: nil)
            viewController?.flipCard(index: second, completion: nil)
        }
        
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flipCard(index: index, completion: nil)
            return
        }
        
        upsideDownSecondIndex = index
        
        if first != index {
            if cards[first] == cards[index] {
                upsideDownFirstIndex = nil
                upsideDownSecondIndex = nil
                
                viewController?.flipCard(index: index, completion: nil)
                viewController?.disableCards(index: first, and: index)
                
                if viewController?.isGameOver() == true {
                    print("GameOver")
                }
            } else {
                viewController?.flipCard(index: index, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shakingCards(index: first, and: index)
                })
            }
        } else {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
        }
    }
    
    private func remove() {
        upsideDownFirstIndex = nil
        upsideDownSecondIndex = nil
        cards.removeAll()
    }
}
