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
        
        print("ROUTER\t\t😈\tRouter")
    }
    
    deinit {
        print("ROUTER\t\t♻️\tRouter")
    }
    
    func initVC() {
        let rootVC = builder.makeMainMenuFlow(router: self)
        navigation.viewControllers = [rootVC]
    }
    
    func popVC(animated: Bool) {
        navigation.popViewController(animated: animated)
    }
    
    func popToRootVC(animated: Bool) {
        navigation.popToRootViewController(animated: animated)
    }
    
    private func errorCase(_ msgLog: String) {
        // FIXME: -- Добавить Alert
        print(msgLog)
        popToRootVC(animated: false)
    }
}

// MARK: - Main Menu Flow
extension Router {
    
    func goToNewGame(animated: Bool) {
        let playVC = builder.makePlayBoardFlow(router: self)
        navigation.pushViewController(playVC, animated: animated)
    }
    
    func goToSettings(animated: Bool) {
        if let mainMenuVC = navigation.topViewController as? MainMenuViewController {
            let settingsVC = builder.makeSettingsFlow()
            settingsVC.modalTransitionStyle = .coverVertical
            settingsVC.modalPresentationStyle = .formSheet
            mainMenuVC.present(settingsVC, animated: animated)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToStatictic(animated: Bool) {
        if let mainMenuVC = navigation.topViewController as? MainMenuViewController {
            let staticticsVC = builder.makeStatisticsFlow()
            staticticsVC.modalTransitionStyle = .coverVertical
            staticticsVC.modalPresentationStyle = .formSheet
            mainMenuVC.present(staticticsVC, animated: animated)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToAbout(animated: Bool) {
        
    }
}

// MARK: - Play Board Flow
extension Router {
    
    func goToGameOver(time: TimeInterval?, taps: UInt, isFinalLevel: Bool, animated: Bool) {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            let gameOverVC = builder.makeGameOverFlow(router: self, time: time, taps: taps, isFinalLevel: isFinalLevel)
            gameOverVC.modalTransitionStyle = .coverVertical
            gameOverVC.modalPresentationStyle = .overFullScreen
            playVC.present(gameOverVC, animated: animated)
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goBackMainMenu(animated: Bool) {
        popVC(animated: animated)
    }
}

// MARK: - Game Over Flow
extension Router {
    
    func goToNextLevel(animated: Bool) {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            if let gameOverVC = playVC.presentedViewController {
                gameOverVC.dismiss(animated: animated) {
                    playVC.presenter?.play(mode: .next)
                }
            } else {
                errorCase("⚠️ [Navigation ERROR]: Presented ViewController is not what was expected")
            }
        } else {
            errorCase("⚠️ [Navigation ERROR]: Top ViewController is not what was expected")
        }
    }
    
    func goToRepeatLevel(animated: Bool) {
        if let playVC = navigation.topViewController as? PlayBoardViewController {
            if let gameOverVC = playVC.presentedViewController {
                gameOverVC.dismiss(animated: animated) {
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
