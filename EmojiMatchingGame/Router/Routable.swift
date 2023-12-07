//
//  Routable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

protocol BasicRoutable {
    var navigation: UINavigationController { get set }
    
    init(navigation: UINavigationController, builder: Buildable)
    func initVC()
}

protocol MainMenuRoutable: BasicRoutable {
    func goToNewGame(animated: Bool)
    func goToSettings(animated: Bool)
    func goToStatictic(animated: Bool)
    func goToAbout(animated: Bool)
}

protocol PlayBoardRoutable: BasicRoutable {
    func goToGameOver(time: TimeInterval?, taps: UInt, isBest: Bool, isFinalLevel: Bool, animated: Bool)
    func goBackMainMenu(animated: Bool)
}

protocol GameOverRoutable: BasicRoutable {
    func goToNextLevel(animated: Bool)
    func goToRepeatLevel(animated: Bool)
}

protocol Routable: BasicRoutable & MainMenuRoutable & PlayBoardRoutable & GameOverRoutable {
    func popVC(animated: Bool)
    func popToRootVC(animated: Bool)
}
