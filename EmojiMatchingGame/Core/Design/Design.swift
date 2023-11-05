//
//  Design.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit


// MARK: - Design Default
//
enum Design {
    
    enum Default {
        static var appearance: (color: UIColor, haptics: Bool, animated: Bool) {
            (color: .systemYellow, haptics: true, animated: true)
        }
    }
}


// MARK: - Typography
//
extension Design {
    
    enum Typography {
        case menu
        case title
        case item
        
        var font: UIFont {
            switch self {
            case .menu:  UIFont.boldSystemFont(ofSize: UIFont.TextStyle.title1.size)
            case .title: UIFont.monospacedDigitSystemFont(forTextStyle: .largeTitle, weight: .light)
            case .item:  UIFont.monospacedDigitSystemFont(forTextStyle: .title1, weight: .thin)
            }
        }
    }
}


// MARK: - Spacing
//
extension Design {
    
    enum Spacing {
        case menu
        case settings
        
        var spacing: CGFloat {
            switch self {
            case .menu:     UIFont.TextStyle.caption2.size
            case .settings: UIFont.TextStyle.title1.size
            }
        }
    }
}


// MARK: - Padding
//
extension Design {
    
    enum Padding {
        case title
        
        var padding: CGFloat {
            switch self {
            case .title: UIFont.TextStyle.largeTitle.size
            }
        }
    }
}
