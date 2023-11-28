//
//  MainMenuDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol MainMenuDisplayable: AnyObject {
    
    var presenter: MainMenuPresentable? { get set }
    
    func display(animated: Bool) 
}
