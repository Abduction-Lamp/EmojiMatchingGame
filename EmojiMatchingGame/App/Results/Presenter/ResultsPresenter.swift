//
//  ResultsPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

final class ResultsPresenter: ResultsPresentable {
    
    private weak var viewController: ResultsDisplayable?
    private let user: UserStorageable
    
    init(_ viewController: ResultsDisplayable, user: UserStorageable) {
        self.viewController = viewController
        self.user = user
        
        print("PRESENTER\t😈\tResults")
    }
    
    deinit {
        print("PRESENTER\t♻️\tResults")
    }
    
    func fetch() {
        Level.allCases.forEach { level in
            var time: String?
            var taps: String?
            if let result = user.bestResults[level.description] {
                time = result.time.toString()
                taps = result.taps.description
            }
            let lock = user.unlockLevel.index < level.index
            viewController?.display(level: (1 + level.index).description, isLock: lock, time: time, taps: taps)
        }
    }
    
    func reset() {
        user.clear()
        fetch()
    }
}
