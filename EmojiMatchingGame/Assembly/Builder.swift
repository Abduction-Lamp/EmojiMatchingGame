//
//  Builder.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

final class Builder: Buildable {
    
    let storage: Storage = (user: User.shared, appearance: Appearance.shared)
    
    func makeMainMenuFlow(router: MainMenuRoutable) -> UIViewController & MainMenuDisplayable {
        let vc = MainMenuViewController()
        let presenter = MainMenuPresenter(vc, router: router)
        vc.presenter = presenter
        return vc
    }
     
    func makePlayBoardFlow(router: PlayBoardRoutable) -> UIViewController & PlayBoardDisplayable {
        let vc = PlayBoardViewController(appearance: storage.appearance)
        let emoji = Emoji()
        let presenter = PlayBoardPresenter(vc, router: router, storage: storage, emoji: emoji)
        vc.presenter = presenter
        return vc
    }
    
    func makeGameOverFlow(router: GameOverRoutable) -> UIViewController & GameOverDisplayable {
        let vc = GameOverViewController()
        let presenter = GameOverPresenter(vc, router: router, storage: storage)
        vc.presenter = presenter
        return vc
    }
    
    
    //
    // TODO: - Logging info
    //
    init() {
        print("ASSEMBLY:\t😈\tBuilder")
        storage.user.fetch()
        storage.appearance.fetch()
    }
    
    deinit {
        print("ASSEMBLY:\t♻️\tBuilder")
    }
}
