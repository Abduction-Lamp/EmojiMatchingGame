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
    
    let animated: Bool
    
    init(_ viewController: GameOverDisplayable, router: GameOverRoutable, animated: Bool) {
        self.viewController = viewController
        self.router = router
        self.animated = animated
        
        print("PRESENTER:\t😈\tGameOver")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tGameOver")
    }
    
    func next() {
        router.goToNextLevel()
    }
    
    func replay() {
        router.goToRepeatLevel()
    }
}
