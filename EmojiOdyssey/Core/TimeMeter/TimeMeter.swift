//
//  TimeMeter.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 02.12.2023.
//

import Foundation

final class TimeMeter {
    
    public static func measure(title: String = "", block: ()-> Void) {
        let start = DispatchTime.now()
        block()
        let end = DispatchTime.now()
        let nanoseconds = end.uptimeNanoseconds - start.uptimeNanoseconds
        let time = Double(nanoseconds) / 1_000_000_000
        print("\(title) > ⏱️ \(time)")
    }
}
