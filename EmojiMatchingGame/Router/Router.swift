//
//  Router.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

final class Router: Routable {
    
    var navigation: UINavigationController
    private var builder: Buildable
    
    init(navigation: UINavigationController, builder: Buildable) {
        self.navigation = navigation
        self.builder = builder
        
        print("ROUTER:\t\t😈\tRouter")
    }
    
    deinit {
        print("ROUTER:\t\t♻️\tRouter")
    }
    
    func initVC() {
        let rootVC = builder.makeMainMenuFlow(router: self)
        navigation.viewControllers = [rootVC]
    }
    
    func popVC() {
        navigation.popViewController(animated: true)
    }
    
    func popToRootVC() {
        navigation.popToRootViewController(animated: true)
    }
    
    private func errorCase(_ msgLog: String) {
        // FIXME: -- Добавить Alert
        print(msgLog)
        popToRootVC()
    }
}

// MARK: - Main Menu Flow
extension Router {
    
    func goToNewGame() {
        let playVC = builder.makePlayBoardFlow(router: self)
        navigation.pushViewController(playVC, animated: true)
    }
    
    func goToSettings() {
        if let mainMenuVC = navigation.topViewController as? MainMenuViewController {
            let settingsVC = builder.makeSettingsFlow()
            settingsVC.modalTransitionStyle = .coverVertical
            settingsVC.modalPresentationStyle = .formSheet
            mainMenuVC.present(settingsVC, animated: true)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToStatictic() {
        if let mainMenuVC = navigation.topViewController as? MainMenuViewController {
            let staticticsVC = builder.makeStatisticsFlow()
            staticticsVC.modalTransitionStyle = .coverVertical
            staticticsVC.modalPresentationStyle = .formSheet
            mainMenuVC.present(staticticsVC, animated: true)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToAbout() {
        
    }
}

// MARK: - Play Board Flow
extension Router {
    
    func goToGameOver(time: TimeInterval?, taps: UInt, isFinalLevel: Bool) {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            let gameOverVC = builder.makeGameOverFlow(router: self, time: time, taps: taps, isFinalLevel: isFinalLevel)
            gameOverVC.modalTransitionStyle = .coverVertical
            gameOverVC.modalPresentationStyle = .overFullScreen
            playVC.present(gameOverVC, animated: true)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goBackMainMenu() {
        popVC()
    }
}

// MARK: - Game Over Flow
extension Router {
    
    func goToNextLevel() {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            if let gameOverVC = playVC.presentedViewController {
                gameOverVC.dismiss(animated: true) {
                    playVC.presenter?.play(mode: .next)
                }
            } else {
                errorCase("⚠️ [Navigation ERROR]: Presented ViewController is not what was expected")
            }
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToRepeatLevel() {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            if let gameOverVC = playVC.presentedViewController {
                gameOverVC.dismiss(animated: true) {
                    playVC.presenter?.play(mode: .current)
                }
            } else {
                errorCase("⚠️ [Navigation ERROR]: Presented ViewController is not what was expected")
            }
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
}
