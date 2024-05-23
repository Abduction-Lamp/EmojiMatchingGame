//
//  Observer.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 03.11.2023.
//

import Foundation

protocol Observer: AnyObject {
    
    var subscribers: [WeakSubscriber] { get }
    
    func register(_ subscriber: Subscriber)
    func unsubscribe(_ subscriber: Subscriber)
    func notify()
}

protocol Subscriber: AnyObject {
    
    func update()
}

protocol WrappedSubscriber {
    
    var wrapped: Subscriber? { get }
}


struct WeakSubscriber: WrappedSubscriber {
    
    weak var wrapped: Subscriber?
    
    init(_ unwrapped: Subscriber) {
        wrapped = unwrapped
    }
}
