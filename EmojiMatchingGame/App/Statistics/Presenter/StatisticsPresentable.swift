//
//  StatisticsPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

protocol StatisticsPresentable: AnyObject {
    
    init(_ viewController: StatisticsDisplayable, user: UserStorageable)
    
    func fetch()
    func reset()
}
