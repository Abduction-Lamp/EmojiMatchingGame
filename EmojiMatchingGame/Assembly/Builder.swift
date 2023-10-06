//
//  Builder.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

final class Builder: Buildable {

    func makeMainMenuFlow(router: MainMenuRoutable) -> UIViewController & MainMenuDisplayable {
        let vc = MainMenuViewController()
        let presenter = MainMenuPresenter(vc, router: router)
        vc.presenter = presenter
        return vc
    }
     
    func makePlayBoardFlow(router: PlayBoardRoutable) -> UIViewController & PlayBoardDisplayable {
        let vc = PlayBoardViewController()
        let presenter = PlayBoardPresenter(vc, router: router, emoji: Emoji())
        vc.presenter = presenter
        return vc
    }
    
    func makeGameOverFlow(router: GameOverRoutable) -> UIViewController & GameOverDisplayable {
        let vc = GameOverViewController()
        let presenter = GameOverPresenter(vc, router: router)
        vc.presenter = presenter
        return vc
    }
    
    
    //
    // TODO: - Logging info
    //
    init() {
        print("ASSEMBLY:\t😈\tBuilder")
    }
    
    deinit {
        print("ASSEMBLY:\t♻️\tBuilder")
    }
}
