//
//  Builder.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

final class Builder: Buildable {
    
    let storage: Storage
    let emoji: EmojiGeneratable
    
    func makeMainMenuFlow(router: MainMenuRoutable) -> UIViewController & MainMenuDisplayable {
        let vc = MainMenuViewController()
        let presenter = MainMenuPresenter(vc, router: router, appearance: storage.appearance)
        vc.presenter = presenter
        return vc
    }
     
    func makePlayBoardFlow(router: PlayBoardRoutable) -> UIViewController & PlayBoardDisplayable {
        let vc = PlayBoardViewController()
        let presenter = PlayBoardPresenter(vc, router: router, storage: storage, emoji: emoji)
        vc.presenter = presenter
        return vc
    }
    
    func makeGameOverFlow(router: GameOverRoutable) -> UIViewController & GameOverDisplayable {
        let vc = GameOverViewController()
        let presenter = GameOverPresenter(vc, router: router, animated: storage.appearance.animated)
        vc.presenter = presenter
        return vc
    }
    
    func makeSettingsFlow() -> UIViewController & SettingsDisplayable {
        let vc = SettingsViewController()
        let presenter = SettingsPresenter(vc, appearance: storage.appearance)
        vc.presenter = presenter
        return vc
    }
    
    
    //
    // TODO: - Logging info
    //
    init(storage: Storage, emoji: EmojiGeneratable) {
        print("ASSEMBLY:\t😈\tBuilder")
        
        self.emoji = emoji
        self.storage = storage
        self.storage.user.fetch()
        self.storage.appearance.fetch()
    }
    
    deinit {
        print("ASSEMBLY:\t♻️\tBuilder")
    }
}
