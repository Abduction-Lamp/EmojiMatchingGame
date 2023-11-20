//
//  PlayBoardDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import UIKit

protocol PlayBoardDisplayable: AnyObject {
    
    var presenter: PlayBoardPresentable? { get set }
    
    func play(level: Sizeable, with sequence: [String], and color: UIColor, animated flag: Bool)
    func setupLevelMenu(unlock: Indexable)
    func selectLevelMenu(level: Indexable)
    
    func disable(index first: Int, and second: Int)
    func flip(index: Int,  animated flag: Bool, completion: ((Bool) -> Void)?)
    func shaking(index first: Int, and second: Int, animated flag: Bool)
    func matching(index first: Int, and second: Int, animated flag: Bool, completion: ((Bool) -> Void)?)
}

extension PlayBoardDisplayable where Self: UIViewController {}
