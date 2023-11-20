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
    private let appearance: AppearanceStorageable
    
    init(_ viewController: MainMenuDisplayable, router: MainMenuRoutable, appearance: AppearanceStorageable) {
        self.viewController = viewController
        self.router = router
        self.appearance = appearance
        
        let memoryAddress = Unmanaged.passUnretained(self).toOpaque()
        print("PRESENTER:\t😈\tMenu > \(memoryAddress)")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tMenu")
    }
}


extension MainMenuPresenter: MainMenuPresentable {
    
    func newGame() {
        router.goToNewGame()
    }
        
    func statistics() {
        router.goToStatictic()
    }
    
    func settings() {
        router.goToSettings()
    }
}

extension MainMenuPresenter: Subscriber {
    
    func update() {
        viewController?.update(animated: appearance.animated)
    }
    
    func viewDidAppear() {
        appearance.register(self)
        viewController?.update(animated: appearance.animated)
    }
    
    func viewDidDisappear() {
        appearance.unsubscribe(self)
    }
}
