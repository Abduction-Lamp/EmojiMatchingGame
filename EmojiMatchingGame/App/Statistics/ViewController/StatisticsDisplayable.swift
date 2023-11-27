//
//  StatisticsDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

protocol StatisticsDisplayable: AnyObject {
    
    var presenter: StatisticsPresentable? { get set }
    
    func setup(level: String?, isLock: Bool, time: String?, taps: String?)
}
