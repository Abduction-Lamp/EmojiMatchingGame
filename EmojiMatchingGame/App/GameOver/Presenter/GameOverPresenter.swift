//
//  GameOverPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.10.2023.
//

import Foundation

final class GameOverPresenter: GameOverPresentable {
    
    private weak var viewController: GameOverDisplayable?
    private let router: GameOverRoutable
    private let storage: Storage
    
    var doWithAnimation: Bool {
        storage.appearance.animated
    }
    
    init(_ viewController: GameOverDisplayable, router: GameOverRoutable, storage: Storage) {
        self.viewController = viewController
        self.router = router
        self.storage = storage
        
        print("PRESENTER:\t😈\tGameOver")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tGameOver")
    }
    
    
    func nextLevel() {
        storage.user.nextLevel()
        router.goToNextLevel()
    }
    
    func repeatLevel() {
        router.goToRepeatLevel()
    }
}
