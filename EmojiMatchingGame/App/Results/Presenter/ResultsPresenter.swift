//
//  ResultsPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

final class ResultsPresenter: ResultsPresentable {
    
    private weak var viewController: ResultsDisplayable?
    private weak var audio: Audible?
    
    private let storage: Storage
    
    init(_ viewController: ResultsDisplayable, audio: Audible, storage: Storage) {
        self.viewController = viewController
        self.audio = audio
        self.storage = storage
    }
    
    func fetch() {
        Level.allCases.forEach { level in
            var time: String?
            var taps: String?
            if let result = storage.user.bestResults[level.description] {
                time = result.time.toString()
                taps = result.taps.description
            }
            let lock = storage.user.unlockLevel.index < level.index
            viewController?.display(level: (1 + level.index).description, isLock: lock, time: time, taps: taps)
        }
    }
    
    func reset() {
        storage.user.clear()
        fetch()
    }
    
    func soundGenerationToDismiss() {
        if storage.appearance.sound {
            audio?.play(.flip1)
        }
    }
    
    func soundGenerationToViewWillAppear() {
        if storage.appearance.sound {
            audio?.play(.flip1)
        }
    }
}
