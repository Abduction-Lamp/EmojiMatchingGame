//
//  Level.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 06.07.2023.
//

import Foundation

protocol Indexable {
    var index: Int { get }
}

protocol Sizeable {
    var size: Int { get }
}

protocol Levelable: Indexable, Sizeable {
    init?(rawValue: Int)
    
    func next() -> Levelable
}


enum Level: CaseIterable, Levelable {
    case one, two, three, four, five, six
    
    var index: Int {
        switch self {
        case .one:   return 0
        case .two:   return 1
        case .three: return 2
        case .four:  return 3
        case .five:  return 4
        case .six:   return 5
        }
    }
    
    var size: Int {
        switch self {
        case .one:   return 2
        case .two:   return 4
        case .three: return 6
        case .four:  return 8
        case .five:  return 10
        case .six:   return 12
        }
    }
        
    init?(rawValue: Int) {
        switch rawValue {
        case 0:  self = .one
        case 1:  self = .two
        case 2:  self = .three
        case 3:  self = .four
        case 4:  self = .five
        case 5:  self = .six
        default: return nil
        }
    }
    
    func next() -> Levelable {
        switch self {
        case .one:        return Self.two
        case .two:        return Self.three
        case .three:      return Self.four
        case .four:       return Self.five
        case .five, .six: return Self.six
        }
    }
}

extension Level: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .one:   return "one"
        case .two:   return "two"
        case .three: return "three"
        case .four:  return "four"
        case .five:  return "five"
        case .six:   return "six"
        }
    }
}
