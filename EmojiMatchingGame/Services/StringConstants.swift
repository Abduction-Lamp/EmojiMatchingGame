//
//  StringConstants.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 28.11.2023.
//

import Foundation

protocol MainMenuLocalizable {
    
    var newGame:    String { get }
    var settings:   String { get }
    var statictics: String { get }
}

protocol Localizable: MainMenuLocalizable { }


struct StringConstants: Localizable {
    
    let newGame:    String = ""
    let settings:   String = ""
    let statictics: String = ""
}
