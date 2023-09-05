//
//  MenuPresenter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import Foundation

protocol MenuPresentable: AnyObject {
    
    init(_ viewController: MenuDisplayable, router: Routable)

    func newGame()
}


final class MenuPresenter: MenuPresentable {
    
    private weak var viewController: MenuDisplayable?
    private let router: Routable
    
    init(_ viewController: MenuDisplayable, router: Routable) {
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
}
