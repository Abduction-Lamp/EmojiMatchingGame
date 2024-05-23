//
//  CardAnimatable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 29.01.2024.
//

import UIKit

protocol CardAnimatable: AnyObject {
    
    func flip(animated flag: Bool, completion: ((Bool) -> Void)?)
    func shake(animated flag: Bool, whih delay: CFTimeInterval)
    func match(animated flag: Bool, whih delay: CFTimeInterval, completion: ((Bool) -> Void)?)
}

extension CardAnimatable where Self: UIView { }
