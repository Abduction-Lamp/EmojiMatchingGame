//
//  UIFont.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 01.11.2023.
//

import UIKit

extension UIFont {
    
    public static func monospacedDigitSystemFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont  {
        let font = UIFont.monospacedDigitSystemFont(ofSize: style.size, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: style)
        let scaled = metrics.scaledFont(for: font)
        return scaled
    }
    
    var height: CGFloat {
        lineHeight.rounded(.up)
    }
}

extension UIFont.TextStyle {
    
    var size: CGFloat {
        switch self {
        case .largeTitle:  34
        case .title1:      28
        case .title2:      22
        case .title3:      20
        case .headline:    17
        case .body:        17
        case .callout:     16
        case .subheadline: 15
        case .footnote:    13
        case .caption1:    12
        case .caption2:    11
        default:           17
        }
    }
    
    var leading: CGFloat {
        switch self {
        case .largeTitle:  41
        case .title1:      34
        case .title2:      28
        case .title3:      25
        case .headline:    22
        case .body:        22
        case .callout:     21
        case .subheadline: 20
        case .footnote:    18
        case .caption1:    16
        case .caption2:    13
        default:           22
        }
    }
}
