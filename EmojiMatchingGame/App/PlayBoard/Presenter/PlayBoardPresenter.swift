//
//  PlayBoardPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.07.2023.
//

import Foundation


protocol PlayBoardPresentable: AnyObject {
    
    init(_ viewController: PlayBoardDisplayable, level: Level, router: Routable, emoji: Emoji)
    
    func play()
    func nextLevel()
    func flip(index: Int)
    
    func goToMenu()
}


final class PlayBoardPresenter {
    
    private weak var viewController: PlayBoardDisplayable?
    private var level: Level
    private let router: Routable
    private let emoji: Emoji
    
    init(_ viewController: PlayBoardDisplayable, level: Level = .one, router: Routable, emoji: Emoji) {
        self.viewController = viewController
        self.level = level
        self.router = router
        self.emoji = emoji
        
        print("PRESENTER:\t😈\tPlayBoard")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tPlayBoard")
    }
    
    private var cards: [String] = []
    private var upsideDownFirstIndex: Int? = nil
    private var upsideDownSecondIndex: Int? = nil
    
    
    private func remove() {
        upsideDownFirstIndex = nil
        upsideDownSecondIndex = nil
        cards.removeAll()
    }
    
    
//    private var isLocked = false
}


extension PlayBoardPresenter: PlayBoardPresentable {
    
    func play() {
        remove()
        cards = emoji.makeSequence(for: level)
        viewController?.play(level: level, with: cards)
    }
    
    func nextLevel() {
        level = level.next()
        play()
    }
    
    func flip(index: Int) {
//        guard isLocked == false else { return }
//        isLocked = true
        
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flipCard(index: first, completion: nil)
            viewController?.flipCard(index: second, completion: nil)
        }
        
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flipCard(index: index) { [weak self] _ in
                guard let self = self else { return }
//                self.isLocked = false
            }
            return
        }
        
        upsideDownSecondIndex = index
        
        if first != index {
            if cards[first] == cards[index] {
                viewController?.disableCards(index: first, and: index)
                
                upsideDownFirstIndex = nil
                upsideDownSecondIndex = nil
                
                viewController?.flipCard(index: index) { [weak self] _ in
                    guard let self = self else { return }
//                    self.isLocked = false
                    self.viewController?.matchingCards(index: first, and: index) { [weak self] _ in
                        guard let self = self else { return }
                        self.viewController?.isGameOver()
                    }
                }
            } else {
                viewController?.flipCard(index: index) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shakingCards(index: first, and: index)
//                    self.isLocked = false
                }
            }
        } else {
            viewController?.flipCard(index: index, completion: nil)
//            { [weak self] _ in
//                guard let self = self else { return }
//                self.isLocked = false
//            }
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
        }
    }

}


extension PlayBoardPresenter {
    
    func goToMenu() {
        router.popToRootVC()
    }
}
