//
//  PlayBoardDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

protocol PlayBoardDisplayable: AnyObject {
    
    var presenter: PlayBoardPresentable? { get set }
    
    
    func play(level: Level, with sequence: [String])
    
    func disableCards(index first: Int, and second: Int)
    
    func flip(index: Int, completion: ((Bool) -> Void)?)
    func shaking(index first: Int, and second: Int)
    func matching(index first: Int, and second: Int, completion: ((Bool) -> Void)?)
}
