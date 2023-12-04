//
//  PlayBoardPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.10.2023.
//

import Foundation

enum LevelGameMode {
    case current
    case next
    case index(Int)
}

protocol PlayBoardPresentable: AnyObject {
    
    var level: Levelable { get }
    
    init(
        _ viewController: PlayBoardDisplayable,
        router:           PlayBoardRoutable,
        storage:          Storage,
        emoji:            EmojiGeneratable
    )
    
    func viewDidLoad()
    
    func play(mode: LevelGameMode)
    func flip(index: Int)
    
    func goBackMainMenu()
}
