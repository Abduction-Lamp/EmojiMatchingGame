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
    
    private let time: TimeInterval?
    private let taps: UInt
    private let isFinalLevel: Bool
    
    
    init(_ viewController: GameOverDisplayable,
         router:           GameOverRoutable,
         animated:         Bool,
         time:             TimeInterval?,
         taps:             UInt,
         isFinalLevel:     Bool) {
        
        self.viewController = viewController
        self.router = router
        self.animated = animated
        
        self.time = time
        self.taps = taps
        self.isFinalLevel = isFinalLevel
        
        print("PRESENTER:\t😈\tGameOver")
    }
    
    deinit {
        print("PRESENTER:\t♻️\tGameOver")
    }
    
    func viewWillAppear() {
        let timeString = time?.toString() ?? ""
        viewController?.setup(time: timeString, taps: taps.description, isFinishMode: isFinalLevel)
    }
    
    func next() {
        router.goToNextLevel()
    }
    
    func replay() {
        router.goToRepeatLevel()
    }
}
