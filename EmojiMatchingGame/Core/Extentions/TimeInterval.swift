//
//  TimeInterval.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

extension TimeInterval {
    
    //  hour:minute:second,(with milliseconds)
    //
    public func toString() -> String {
        let fornatter = DateComponentsFormatter()
        fornatter.allowedUnits = [.hour, .minute, .second]
        fornatter.unitsStyle = .positional
        guard let output = fornatter.string(from: self) else { return "" }
        let milliseconds = Int(self.truncatingRemainder(dividingBy: 1) * 1000)
        return output + ",\(milliseconds)"
    }
}
