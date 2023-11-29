//
//  StatisticsViewSetupable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 27.11.2023.
//

import UIKit

protocol StatisticsViewSetupable: AnyObject where Self: UIView {

    func setup(level: UIImage?, time: String?, taps: String?, font: UIFont)
    func clean()
    
    func resetAddTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event)
}


extension StatisticsViewSetupable {
    
    func setup(level: UIImage?, time: String?, taps: String?, font: UIFont = Design.Typography.font(.item)) {
        setup(level: level, time: time, taps: taps, font: font)
    }
}
