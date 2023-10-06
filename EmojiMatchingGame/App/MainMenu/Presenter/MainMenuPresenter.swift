//
//  MainMenuPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import Foundation

final class MainMenuPresenter {
    
    private weak var viewController: MainMenuDisplayable?
    private let router: MainMenuRoutable
    
    init(_ viewController: MainMenuDisplayable, router: MainMenuRoutable) {
        self.viewController = viewController
        self.router = router
        
        print("PRESENTER:\t😈\tMenu")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tMenu")
    }
}

extension  MainMenuPresenter: MainMenuPresentable {
    
    func newGame() {
        router.goToNewGame()
    }
    
    func settings() {
        router.goToSettings()
    }
    
    func statistics() {
        router.goToStatictic()
    }
}
