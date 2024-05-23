//
//  ResultsPresentable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

protocol ResultsPresentable: AnyObject {
    
    init(_ viewController: ResultsDisplayable, audio: Audible, storage: Storage)
    
    func fetch()
    func reset()
    
    func soundGenerationToViewWillAppear()
    func soundGenerationToDismiss()
}
