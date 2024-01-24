//
//  PlayBoardPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.07.2023.
//

import Foundation
import AVFoundation

final class PlayBoardPresenter {
    
    private weak var viewController: PlayBoardDisplayable?
    
    private let router: PlayBoardRoutable
    private let storage: Storage
    private let emoji: EmojiGeneratable
    private let audio: Audible
    
    var level: Levelable
    
    init(_ viewController: PlayBoardDisplayable, router: PlayBoardRoutable, storage: Storage, emoji: EmojiGeneratable, audio: Audible) {
        self.viewController = viewController
        self.router = router
        self.storage = storage
        self.emoji = emoji
        self.audio = audio
        
        level = storage.user.startLevel
        
        print("PRESENTER\t😈\tPlayBoard")
    }
    
    deinit {
        print("PRESENTER\t♻️\tPlayBoard")
    }
    
    private var cards: [String] = []
    private var remainingCards: Int = 0
    private var upsideDownFirstIndex: Int? = nil
    private var upsideDownSecondIndex: Int? = nil
    
    private var startTime: Date? = nil
    private var taps: UInt = 0
}


extension PlayBoardPresenter: PlayBoardPresentable {
    
    func viewDidLoad() {
        viewController?.setupLevelMenu(unlock: storage.user.unlockLevel)
        viewController?.setupSoundButton(volume: storage.appearance.sound ? storage.appearance.volume : 0.0)
        play(mode: .current)
    }
    
    func play(mode: LevelGameMode) {
        switch mode {
        case .current: 
            break
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
        audio.play(.flip)
        
        if startTime == nil { startTime = Date.now }
        taps += 1
        
        let animated = storage.appearance.animated
        ///
        /// Если уже две карты перевернуты, но не совпали, то переворачиваем их обратно (рубашкой вверх)
        ///
        if let first = upsideDownFirstIndex, let second = upsideDownSecondIndex {
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
            viewController?.flip(index: first, animated: animated, completion: nil)
            viewController?.flip(index: second, animated: animated, completion: nil)
        }
        
        ///
        /// Если нет перевернутых карт, то переворачиваем одну и на этом все
        ///
        guard let first = upsideDownFirstIndex else {
            upsideDownFirstIndex = index
            viewController?.flip(index: index, animated: animated, completion: nil)
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
                
                viewController?.flip(index: index, animated: animated) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.matching(index: first, and: index, animated: animated) { [weak self] _ in
                        guard let self = self else { return }
                        self.remainingCards -= 2
                        if self.isGameOver {
                            let result = self.saveResult()
                            self.unlock()
                            self.router.goToGameOver(time: result?.result.time,
                                                     taps: result?.result.taps ?? self.taps,
                                                     isBest: result?.isBest ?? false,
                                                     isFinalLevel: self.isFinalLevel,
                                                     animated: animated)
                        }
                    }
                }
            } else {
                viewController?.flip(index: index, animated: storage.appearance.animated) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewController?.shaking(index: first, and: index, animated: animated)
                }
            }
        } else {
            viewController?.flip(index: index, animated: animated, completion: nil)
            upsideDownFirstIndex = nil
            upsideDownSecondIndex = nil
        }
    }
    
    
    private func remove() {
        startTime = nil
        upsideDownFirstIndex = nil
        upsideDownSecondIndex = nil
        cards.removeAll()
        remainingCards = 0
        taps = 0
    }
    
    private func saveResult() -> (result: User.BestResult, isBest: Bool)? {
        guard let start = startTime else { return nil }
        let time = Date.now.timeIntervalSince(start)
        let result = User.BestResult.init(time: time, taps: taps)
        var isBest = true
        if let best = storage.user.getBestResult(for: level) {
            isBest = result < best
        }
        storage.user.setBestResult(for: level, result: result)
        return (result: result, isBest: isBest)
    }
    
    private func unlock() {
        if level.index == storage.user.unlockLevel.index {
            storage.user.unlock()
            viewController?.setupLevelMenu(unlock: storage.user.unlockLevel)
        }
    }
    
    private var isGameOver: Bool {
        return remainingCards == 0
    }
    
    private var isFinalLevel: Bool {
        if let last = Level.allCases.last, last.index == level.index {
            return true
        }
        return false
    }
}


extension PlayBoardPresenter {
    
    func goBackMainMenu() {
        audio.play(.navigation)
        router.goBackMainMenu(animated: storage.appearance.animated)
    }
    
    func sound() {
        storage.appearance.sound = !storage.appearance.sound
        viewController?.setupSoundButton(volume: storage.appearance.sound ? storage.appearance.volume : 0.0)
        audio.play(.navigation)
    }
}
