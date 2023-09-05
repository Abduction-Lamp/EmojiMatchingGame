//
//  Router.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit


final class Router: Routable {
    
    var navigation: UINavigationController
    var builder: Buildable
    
    
    init(navigation: UINavigationController, builder: Buildable) {
        self.navigation = navigation
        self.builder = builder
        
        print("ROUTER:\t\t😈\tRouter")
    }
    
    deinit {
        print("ROUTER:\t\t♻️\tRouter")
    }
    
    
    
    func initVC() {
        let rootVC = builder.makeMenuFlow(router: self)
        navigation.viewControllers = [rootVC]
    }
    
    func pushNewGameVC() {
        let playVC = builder.makePlayFlow(router: self)
        navigation.pushViewController(playVC, animated: true)
    }
    
    func popToMenuVC() {
        let menuVC = builder.makeMenuFlow(router: self)
        navigation.popToViewController(menuVC, animated: true)
    }
    
    func popVC() {
        navigation.popViewController(animated: true)
    }
    
    func popToRootVC() {
        navigation.popToRootViewController(animated: true)
    }
}
