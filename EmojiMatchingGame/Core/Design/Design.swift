//
//  Design.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit


// MARK: - Design Default
//
public enum Design {
    
    // MARK: Platform
    public enum Platform: Int, Equatable {
        case iOS15 = 15, iOS16, iOS17
        
        static var this: Platform {
            if #available(iOS 17, *) { return .iOS17 }
            if #available(iOS 16, *) { return .iOS16 }
            if #available(iOS 15, *) { return .iOS15 }
        }
    }
    
    // MARK: Default
    public enum Default {
        static var appearance: (color: UIColor, animated: Bool, sound: Bool, volume: Float) {
            (color: .systemYellow, animated: true, sound: true, volume: 1.0)
        }
    }
    
    // MARK: Size Class
    public enum PseudoUserInterfaceSizeClass {
        case compact, regular

        static var current: PseudoUserInterfaceSizeClass {
            (UIScreen.main.bounds.width < UIScreen.main.bounds.height) ? .compact : .regular
        }
    }
}


// MARK: - Typography
//
extension Design {
    
    public enum Typography {
        case menu, title, item
        
        static func font(_ flow: Typography) -> UIFont {
            switch flow {
            case .menu:  UIFont.systemFont(ofSize: UIFont.TextStyle.title1.size).bold(on: true)
            case .title: UIFont.monospacedDigitSystemFont(forTextStyle: .largeTitle, weight: .light)
            case .item:  UIFont.monospacedDigitSystemFont(forTextStyle: .title1, weight: .thin)
            }
        }
    }
}


// MARK: - Padding, Spacing & Content Insets
//
extension Design {
    
    public enum Padding {
        case menu, title, item
        
        var spacing: CGFloat {
            switch self {
            case .menu:  UIFont.TextStyle.caption2.size
            case .title: UIFont.TextStyle.largeTitle.size
            case .item:  UIFont.TextStyle.title1.size
            }
        }
    }
    
    public enum EdgeInsets {
        case menu, navigation
        
        var edge: NSDirectionalEdgeInsets {
            switch self {
            case .menu:       NSDirectionalEdgeInsets(top: 20, leading: 75, bottom: 20, trailing: 75)
            case .navigation: NSDirectionalEdgeInsets(top: 17, leading: 17, bottom: 17, trailing: 17)
            }
        }
    }
}
