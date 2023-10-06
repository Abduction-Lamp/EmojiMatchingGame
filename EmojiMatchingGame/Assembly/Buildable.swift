//
//  Buildable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

protocol Buildable: AnyObject {
    func makeMainMenuFlow (router: MainMenuRoutable)  -> UIViewController & MainMenuDisplayable
    func makePlayBoardFlow(router: PlayBoardRoutable) -> UIViewController & PlayBoardDisplayable
    func makeGameOverFlow (router: GameOverRoutable)  -> UIViewController & GameOverDisplayable
}
