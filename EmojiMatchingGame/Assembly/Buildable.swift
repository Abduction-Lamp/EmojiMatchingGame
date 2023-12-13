//
//  Buildable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

protocol Buildable: AnyObject {
    func makeMainMenuFlow(router: MainMenuRoutable) -> UIViewController & MainMenuDisplayable
    func makePlayBoardFlow(router: PlayBoardRoutable) -> UIViewController & PlayBoardDisplayable
    func makeGameOverFlow(router: GameOverRoutable, time: TimeInterval?, taps: UInt, isBest: Bool, isFinalLevel: Bool) -> UIViewController & GameOverDisplayable
    func makeSettingsFlow() -> UIViewController & SettingsDisplayable
    func makeResultsFlow() -> UIViewController & ResultsDisplayable
}
