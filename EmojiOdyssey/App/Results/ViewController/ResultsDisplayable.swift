//
//  ResultsDisplayable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

protocol ResultsDisplayable: AnyObject {
    
    var presenter: ResultsPresentable? { get set }
    
    func display(level: String?, isLock: Bool, time: String?, taps: String?)
}
