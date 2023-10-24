//
//  PlayBoardPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.07.2023.
//

import Foundation

final class PlayBoardPresenter {
    
    private weak var viewController: PlayBoardDisplayable?
    
    private let router: PlayBoardRoutable
    private let storage: Storage
    private let emoji: Emoji
    
    init(_ viewController: PlayBoardDisplayable, router: PlayBoardRoutable, storage: Storage, emoji: Emoji) {
        self.viewController = viewController
        self.router = router
        self.storage = storage
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
}


extension PlayBoardPresenter: PlayBoardPresentable {
    
    func play() {
        remove()
        let level = storage.user.unlockLevel
        cards = emoji.makeSequence(for: level)
        remainingCards = cards.count
        
        viewController?.play(level: level, with: cards)
    }

    func flip(index: Int) {
        ///
        /// Если уже две карты перевернуты, но не совпали, то переворачиваем их обратно (рубашкой вверх)
        ///
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flip(index: first, completion: nil)
            viewController?.flip(index: second, completion: nil)
        }
        
        ///
        /// Если нет перевернутых карт, то переворачиваем одну и на этом все
        ///
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flip(index: index, completion: nil)
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
                viewController?.disable(index: first, and: index)
                
                upsideDownFirstIndex = nil
                upsideDownSecondIndex = nil
                
                viewController?.flip(index: index) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.matching(index: first, and: index) { [weak self] _ in
                        guard let self = self else { return }
                        self.remainingCards -= 2
                        if isGameOver { 
                            self.router.goToGameOver()
                        }
                    }
                }
            } else {
                viewController?.flip(index: index) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shaking(index: first, and: index)
                }
            }
        } else {
            viewController?.flip(index: index, completion: nil)
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
        }
    }
    
    
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


extension PlayBoardPresenter {
    
    func goBackMainMenu() {
        router.goBackMainMenu()
    }
}
