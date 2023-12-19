//
//  TimeInterval.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import Foundation

extension TimeInterval {
    
    /// Вернет строку
    /// [hour] : [minute] : second , milliseconds
    ///
    public func toString(_ unitsStyle: DateComponentsFormatter.UnitsStyle = .positional) -> String {
        let fornatter = DateComponentsFormatter()
        fornatter.allowedUnits = [.hour, .minute, .second]
        fornatter.unitsStyle = unitsStyle
        guard let output = fornatter.string(from: self) else { return "" }
        
        let truncatingRemainder = self.truncatingRemainder(dividingBy: 1) * 1000
        let roundedMilliseconds = Int(truncatingRemainder.rounded(.toNearestOrAwayFromZero))
        let milliseconds = String(format: "%03d", roundedMilliseconds)
        
        return output + ",\(milliseconds)"
    }
}
