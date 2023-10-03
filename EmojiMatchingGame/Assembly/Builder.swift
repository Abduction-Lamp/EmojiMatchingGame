//
//  Builder.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

final class Builder: Buildable {
    
    func makeMenuFlow(router: Routable) -> UIViewController & MainMenuDisplayable {
        let vc = MainMenuViewController()
        let presenter = MainMenuPresenter(vc, router: router)
        vc.presenter = presenter
        return vc
    }
    
    func makePlayFlow(router: Routable) -> UIViewController & PlayBoardDisplayable {
        let vc = PlayBoardViewController()
        let presenter = PlayBoardPresenter(vc, router: router, emoji: Emoji())
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
    
    
    func makeSettingsFlow() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        vc.modalTransitionStyle = .partialCurl
        vc.modalPresentationStyle = .popover
        return vc
    }
}
