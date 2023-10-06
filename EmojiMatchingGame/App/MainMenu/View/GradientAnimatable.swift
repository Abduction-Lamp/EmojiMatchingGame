//
//  GradientAnimatable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol GradientAnimatable: AnyObject {
    
    func animate(with duration: CFTimeInterval)
    func stop()
}
