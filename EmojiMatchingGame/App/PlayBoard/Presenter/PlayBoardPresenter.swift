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
    private var remainingCards: Int = 0
    private var upsideDownFirstIndex: Int? = nil
    private var upsideDownSecondIndex: Int? = nil
    
    
    private func remove() {
        upsideDownFirstIndex = nil
        upsideDownSecondIndex = nil
        cards.removeAll()
        remainingCards = 0
    }
    
    private var isGameOver: Bool {
        return remainingCards == 0
    }
}


extension PlayBoardPresenter: PlayBoardPresentable {
    
    func play() {
        remove()
        cards = emoji.makeSequence(for: level)
        remainingCards = cards.count
        
        viewController?.play(level: level, with: cards)
    }
    
    func nextLevel() {
        level = level.next()
        play()
    }
    
    func flip(index: Int) {
        ///
        /// Если уже две карты перевернуты, но не совпали, то переворачиваем их обратно (рубашкой вверх)
        ///
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flipCard(index: first, completion: nil)
            viewController?.flipCard(index: second, completion: nil)
        }
        
        ///
        /// Если нет перевернутых карт, то переворачиваем одну и на этом все
        ///
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flipCard(index: index, completion: nil)
            return
        }
        
        upsideDownSecondIndex = index
        
        if first != index {
            ///
            /// Карты совпали:
            ///     1 - Блокируем карты, чтобы во время анимации нельзя было с картами взаимодействовать
            ///     2 - Анимация переворота карты
            ///     3 - Анимация совпадения карты
            ///     4 - Проверяем все окончание игры
            ///
            if cards[first] == cards[index] {
                viewController?.disableCards(index: first, and: index)
                
                upsideDownFirstIndex = nil
                upsideDownSecondIndex = nil
                
                viewController?.flipCard(index: index) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.matchingCards(index: first, and: index) { [weak self] _ in
                        guard let self = self else { return }
                        self.remainingCards -= 2
                        if isGameOver {
                            self.viewController?.isGameOver()
                        }
                    }
                }
            } else {
                viewController?.flipCard(index: index) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shakingCards(index: first, and: index)
                }
            }
        } else {
            viewController?.flipCard(index: index, completion: nil)
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
