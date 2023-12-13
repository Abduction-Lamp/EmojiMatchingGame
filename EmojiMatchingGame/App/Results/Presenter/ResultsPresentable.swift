//
//  ResultsPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

protocol ResultsPresentable: AnyObject {
    
    init(_ viewController: ResultsDisplayable, user: UserStorageable)
    
    func fetch()
    func reset()
}
