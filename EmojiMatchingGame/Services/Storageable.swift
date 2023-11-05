//
//  Storageable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 20.10.2023.
//

import UIKit

protocol Storageable: AnyObject {
    func fetch()
    func clear()
}


protocol UserStorageable: Storageable {
    
    var unlockLevel: Level { get set }
    var startLevel:  Level { get set }
    
    func nextLevel()
}

protocol AppearanceStorageable: Storageable, Observer {
    
    var color:    UIColor { get set }
    var haptics:  Bool    { get set }
    var animated: Bool    { get set }
    
    var isSupportsHaptics: Bool { get }
}


typealias Storage = (user: UserStorageable, appearance: AppearanceStorageable)
