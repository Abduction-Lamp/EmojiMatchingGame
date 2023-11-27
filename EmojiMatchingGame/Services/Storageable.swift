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


protocol UserStorageable: Storageable, CustomStringConvertible {
    
    var unlockLevel: Levelable { get set }
    var startLevel:  Levelable { get set }
   
    var bestResults: [String: User.BestResult] { get }
    func getBestResult(for level: Levelable) -> User.BestResult?
    func setBestResult(for level: Levelable, result: User.BestResult)
    
    func unlock()
}

protocol AppearanceStorageable: Storageable, Observer {
    
    var color:    UIColor { get set }
    var haptics:  Bool    { get set }
    var animated: Bool    { get set }
    
    var isSupportsHaptics: Bool { get }
}


typealias Storage = (user: any UserStorageable, appearance: AppearanceStorageable)
