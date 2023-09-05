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
}


protocol Routable: BasicRoutable {
    
    init(navigation: UINavigationController, builder: Buildable)
    
    func initVC()
    
    func pushNewGameVC()
    
    func popToMenuVC()

    func popVC()
    func popToRootVC()
}

