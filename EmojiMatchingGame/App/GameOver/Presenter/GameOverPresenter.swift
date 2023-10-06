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
    
    init(_ viewController: GameOverDisplayable, router: GameOverRoutable) {
        self.viewController = viewController
        self.router = router
        
        print("PRESENTER:\t😈\tGameOver")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tGameOver")
    }
    
    
    func nextLevel() {
        router.goToNextLevel()
    }
    
    func repeatLevel() {
        router.goToRepeatLevel()
    }
}
