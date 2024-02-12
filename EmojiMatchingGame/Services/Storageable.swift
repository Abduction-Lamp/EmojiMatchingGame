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
    var unlockLevel: Levelable { get set }
    var startLevel:  Levelable { get set }
   
    var bestResults: [String: User.BestResult] { get }
    func getBestResult(for level: Levelable) -> User.BestResult?
    func setBestResult(for level: Levelable, result: User.BestResult)
    
    func unlock()
}


protocol AppearanceStorageable: Storageable, AudioAppearanceProtocol, Observer {
    var mode:     UIUserInterfaceStyle  { get set }
    func fetchOnliMode()
    
    var color:    UIColor               { get set }
    var animated: Bool                  { get set }
    
    var sound:    Bool                  { get set }
    var volume:   Float                 { get set }
}

protocol AudioAppearanceProtocol: AnyObject {
    var sound:  Bool  { get }
    var volume: Float { get }
}


typealias Storage = (user: any UserStorageable, appearance: AppearanceStorageable)
