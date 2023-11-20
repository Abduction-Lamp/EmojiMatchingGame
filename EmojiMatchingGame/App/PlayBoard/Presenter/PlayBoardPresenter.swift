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
    private let emoji: EmojiGeneratable
    
    private var level: Levelable
    
    init(_ viewController: PlayBoardDisplayable, router: PlayBoardRoutable, storage: Storage, emoji: EmojiGeneratable) {
        self.viewController = viewController
        self.router = router
        self.storage = storage
        self.emoji = emoji
        
        level = storage.user.startLevel
        
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
        
    func viewDidLoad() {
        viewController?.setupLevelMenu(unlock: storage.user.unlockLevel)
        play(mode: .current)
    }
    
    func play(mode: LevelGameMode) {
        
        switch mode {
        case .current: break
        case .next:
            if level.index < storage.user.unlockLevel.index {
                level = level.next()
            }
        case let .index(index):
            if index <= storage.user.unlockLevel.index, let new = Level(rawValue: index) {
                level = new
            }
        }
        
        remove()
        viewController?.selectLevelMenu(level: level)
        
        cards = emoji.makeSequence(for: level)
        remainingCards = cards.count
        
        viewController?.play(level: level, with: cards, and: storage.appearance.color, animated: storage.appearance.animated)
    }


    func flip(index: Int) {
        ///
        /// Если уже две карты перевернуты, но не совпали, то переворачиваем их обратно (рубашкой вверх)
        ///
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flip(index: first, animated: storage.appearance.animated, completion: nil)
            viewController?.flip(index: second, animated: storage.appearance.animated, completion: nil)
        }
        
        ///
        /// Если нет перевернутых карт, то переворачиваем одну и на этом все
        ///
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flip(index: index, animated: storage.appearance.animated, completion: nil)
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
                
                viewController?.flip(index: index, animated: storage.appearance.animated) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.matching(index: first, and: index, animated: storage.appearance.animated) { [weak self] _ in
                        guard let self = self else { return }
                        self.remainingCards -= 2
                        if isGameOver {
                            if level.index == storage.user.unlockLevel.index {
                                storage.user.unlock()
                                viewController?.setupLevelMenu(unlock: storage.user.unlockLevel)
                            }
                            if let last = Level.allCases.last,
                               last.index == level.index {
                                self.router.goToGameOver(isFinalLevel: true)
                            } else {
                                self.router.goToGameOver(isFinalLevel: false)
                            }
                            
                        }
                    }
                }
            } else {
                viewController?.flip(index: index, animated: storage.appearance.animated) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shaking(index: first, and: index, animated: storage.appearance.animated)
                }
            }
        } else {
            viewController?.flip(index: index, animated: storage.appearance.animated, completion: nil)
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
