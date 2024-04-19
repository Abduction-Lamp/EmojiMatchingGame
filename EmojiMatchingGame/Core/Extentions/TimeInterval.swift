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
        let dateFornatter = DateComponentsFormatter()
        dateFornatter.allowedUnits = [.hour, .minute, .second]
        dateFornatter.unitsStyle = unitsStyle
        guard let output = dateFornatter.string(from: self) else { return "" }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.minimumIntegerDigits = 3
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        
        let truncatingRemainder = self.truncatingRemainder(dividingBy: 1) * 1000
        let roundedMilliseconds = Int(truncatingRemainder.rounded(.toNearestOrAwayFromZero))
        let milliseconds = numberFormatter.string(from: NSNumber(value: roundedMilliseconds))
            
        return output + ",\(milliseconds ?? "")"
    }
}
