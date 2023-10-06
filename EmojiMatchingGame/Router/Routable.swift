//
//  Routable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

protocol BasicRoutable {
    var navigation: UINavigationController { get set }
    var builder: Buildable { get set }
    
    init(navigation: UINavigationController, builder: Buildable)
    func initVC()
}

protocol MainMenuRoutable: BasicRoutable {
    func goToNewGame()
    func goToSettings()
    func goToStatictic()
    func goToAbout()
}

protocol PlayBoardRoutable: BasicRoutable {
    func goToGameOver()
    func goBackMainMenu()
}

protocol GameOverRoutable: BasicRoutable {
    func goToNextLevel()
    func goToRepeatLevel()
}

protocol Routable: BasicRoutable & MainMenuRoutable & PlayBoardRoutable & GameOverRoutable {
    func popVC()
    func popToRootVC()
}
