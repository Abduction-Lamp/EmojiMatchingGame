//
//  Emoji.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.07.2023.
//

import Foundation

protocol EmojiGeneratable {
    
    init(flag service: FlagGeneratable)
    func sequence(for level: Sizeable) -> [String]
}


fileprivate
let exception: [Int] = [
    0x02122,    /// ™️
    0x025AA,    /// ▪️
    0x025AB,    /// ▫️
    0x025FB,    /// ◻️
    0x025FC,    /// ◼️
    0x025FD,    /// ◽️
    0x025FE,    /// ◾️
    0x02640,    /// ♀️
    0x02642,    /// ♂️
    0x0267E,    /// ♾️
    0x02714,    /// ✔️
    0x02716,    /// ✖️
    0x0274C,    /// ❌️
    0x02754,    /// ❔️
    0x02755,    /// ❕️
    0x02795,    /// ➕️
    0x02796,    /// ➖️
    0x02797,    /// ➗️
    0x027B0,    /// ➰️
    0x027BF,    /// ➿️
    0x02B1B,    /// ⬛️
    0x02B1C,    /// ⬜️
    0x03030,    /// 〰️
    0x1F3FB,    ///
    0x1F3FC,    ///
    0x1F3FD,    ///
    0x1F3FE,    ///
    0x1F3FF,    ///
    0x1F4AE,    /// 💮️
    0x1F4B1,    /// 💱️
    0x1F4B2,    /// 💲️
    0x1F519,    /// 🔙️
    0x1F51A,    /// 🔚️
    0x1F51B,    /// 🔛️
    0x1F51C,    /// 🔜️
    0x1F51D,    /// 🔝️
    0x1F532,    /// 🔲️
    0x1F533,    /// 🔳️
    0x1F534,    /// 🔴️
    0x1F535,    /// 🔵️
    0x1F536,    /// 🔶️
    0x1F537,    /// 🔷️
    0x1F538,    /// 🔸️
    0x1F539,    /// 🔹️
    0x1F53A,    /// 🔺️
    0x1F53B,    /// 🔻️
    0x1F7E0,    /// 🟠️
    0x1F7E1,    /// 🟡️
    0x1F7E2,    /// 🟢️
    0x1F7E3,    /// 🟣️
    0x1F7E4,    /// 🟤️
    0x1F7E5,    /// 🟥️
    0x1F7E6,    /// 🟦️
    0x1F7E7,    /// 🟧️
    0x1F7E8,    /// 🟨️
    0x1F7E9,    /// 🟩️
    0x1F7EA,    /// 🟪️
    0x1F7EB,    /// 🟫️
    0x1F7F0,    /// 🟰️
    0x1F9B0,    /// 🦰️
    0x1F9B1,    /// 🦱️
    0x1F9B2,    /// 🦲️
    0x1F9B3,    /// 🦳️
]


fileprivate
let ban: [Int] = []



final class Emoji: EmojiGeneratable {
    
    private let flag: FlagGeneratable
    private var list: [String] = []
    
    init(flag service: any FlagGeneratable = Flag()) {
        flag = service
        list.reserveCapacity(1500)
        search()
    }
    
    
    /// Генерирует последовательность строк для уровня игры на основе указанного размера.
    ///
    /// - Parameter level: Размер уровня игры, реализующий протокол `Sizeable`.
    /// - Returns: Массив строк, представляющих собой сгенерированную последовательность случайных emoji.
    ///
    /// Если в sequence попала буква, с помощью которой кодируеться флаг
    /// то меняем эту букву на случайный флаг
    ///
    func sequence(for level: any Sizeable) -> [String] {
        let count: Int = (level.size * level.size) / 2
        guard (count % 2) == 0 else { return [] }

        var sequence = list.shuffled(only: count).map { emoji in
            if let scalar = emoji.unicodeScalars.first?.value, flag.range.contains(scalar) {
                return flag.random()
            }
            return emoji
        }
        sequence += sequence
        return sequence.shuffled()
    }

    
    ///
    /// Среди символов в диапозоне 0x01000 ... 0x1FFFF ищим те символы, которые являються emoji
    /// Со временем, по мере появление новых emoji, диапозон может измениться.
    /// На данный момент в этот диапозн попадают все emoji
    ///
    /// При поиски исключаються некоторые emoji из списка exception
    ///
    private func search(_ range: ClosedRange<Int> = 0x01000 ... 0x1FFFF) {
        let VS16: String = "\u{FE0F}"
        for scalar in range {
            if let unicode = UnicodeScalar(scalar) {
                if unicode.properties.isEmoji && !exception.contains(scalar) {
                    let emoji = "\(String(unicode))\(unicode.properties.isEmojiPresentation ? "" : VS16)"
                    list.append(emoji)
                }
            }
        }
    }
}
