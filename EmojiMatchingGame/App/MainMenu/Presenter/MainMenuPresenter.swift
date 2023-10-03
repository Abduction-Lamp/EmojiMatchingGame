//
//  MainMenuPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import Foundation

protocol MainMenuPresentable: AnyObject {
    
    init(_ viewController: MainMenuDisplayable, router: Routable)

    func newGame()
    func settings()
    func statistics()
}


final class MainMenuPresenter: MainMenuPresentable {
    
    private weak var viewController: MainMenuDisplayable?
    private let router: Routable
    
    init(_ viewController: MainMenuDisplayable, router: Routable) {
        self.viewController = viewController
        self.router = router
        
        print("PRESENTER:\t😈\tMenu")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tMenu")
    }
    
    func newGame() {
        router.pushNewGameVC()
    }
    
    func settings() {
        router.pushNewGameVC()
    }
    
    func statistics() {
        router.pushNewGameVC()
    }
}
