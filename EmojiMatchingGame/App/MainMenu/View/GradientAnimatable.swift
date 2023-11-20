//
//  GradientAnimatable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import UIKit

protocol GradientAnimatable: AnyObject where Self: UIView {
    
    func animate(with duration: CFTimeInterval)
    func stop()
}
