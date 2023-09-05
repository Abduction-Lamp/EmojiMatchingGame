//
//  Level.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.07.2023.
//

import Foundation

enum Level: Int {
    case one   = 2
    case two   = 4
    case three = 6
    case four  = 8
    case five  = 10
    case six   = 12
    
    func next() -> Level {
        switch self {
        case .one:   return .two
        case .two:   return .three
        case .three: return .four
        case .four:  return .five
        case .five:  return .six
        case .six:   return .one
        }
    }
}
