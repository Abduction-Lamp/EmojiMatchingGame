//
//  Emoji.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.07.2023.
//

import Foundation


protocol EmojiGeneratable {
    
    init(flag service: FlagGeneratable)
    func makeSequence(for level: Sizeable) -> [String]
}


//
// Содержит диапазоны Unicode для различных групп простых (не составных) эмодзи
// Всего 1378 элемента
//                              // #    count   - Описание
//
fileprivate let unicodeEmojiList = [
    0x0203C ... 0x0203C,        // 0    (1)     -
    0x02049 ... 0x02049,        // 1    (1)     -
    0x02139 ... 0x02139,        // 2    (1)     -
    0x02194 ... 0x02199,        // 3    (6)     -
    0x021A9 ... 0x021AA,        // 4    (2)     -
    0x0231A ... 0x0231B,        // 5    (2)     -
    0x02328 ... 0x02328,        // 6    (1)     -
    0x023CF ... 0x023CF,        // 7    (1)     -
    0x023E9 ... 0x023F3,        // 8    (11)    -
    0x023F8 ... 0x023FA,        // 9    (3)     -
    0x024C2 ... 0x024C2,        // 10   (1)     -
    0x025B6 ... 0x025B6,        // 11   (1)     -
    0x025C0 ... 0x025C0,        // 12   (1)     -
    0x02600 ... 0x02604,        // 13   (5)     -
    0x0260E ... 0x0260E,        // 14   (1)     -
    0x02611 ... 0x02611,        // 15   (1)     -
    0x02614 ... 0x02615,        // 16   (2)     -
    0x02618 ... 0x02618,        // 17   (1)     -
    0x0261D ... 0x0261D,        // 18   (1)     -
    0x02620 ... 0x02620,        // 19   (1)     -
    0x02622 ... 0x02623,        // 20   (2)     -
    0x02626 ... 0x02626,        // 21   (1)     -
    0x0262A ... 0x0262A,        // 22   (1)     -
    0x0262E ... 0x0262F,        // 23   (2)     -
    0x02638 ... 0x0263A,        // 24   (3)     -
    0x02648 ... 0x02653,        // 25   (12)    -
    0x0265F ... 0x02660,        // 26   (2)     -
    0x02663 ... 0x02663,        // 27   (1)     -
    0x02665 ... 0x02666,        // 28   (2)     -
    0x02668 ... 0x02668,        // 29   (1)     -
    0x0267B ... 0x0267B,        // 30   (1)     -
    0x0267E ... 0x0267F,        // 31   (2)     -
    0x02692 ... 0x02697,        // 32   (6)     -
    0x02699 ... 0x02699,        // 33   (1)     -
    0x0269B ... 0x0269C,        // 34   (2)     -
    0x026A0 ... 0x026A1,        // 35   (2)     -
    0x026A7 ... 0x026A7,        // 36   (1)     -
    0x026AA ... 0x026AB,        // 37   (2)     -
    0x026B0 ... 0x026B1,        // 38   (2)     -
    0x026BD ... 0x026BE,        // 39   (2)     -
    0x026C4 ... 0x026C5,        // 40   (2)     -
    0x026C8 ... 0x026C8,        // 41   (1)     -
    0x026CE ... 0x026CF,        // 42   (2)     -
    0x026D1 ... 0x026D1,        // 43   (1)     -
    0x026D3 ... 0x026D4,        // 44   (2)     -
    0x026E9 ... 0x026EA,        // 45   (2)     -
    0x026F0 ... 0x026F5,        // 46   (6)     -
    0x026F7 ... 0x026FA,        // 47   (4)     -
    0x026FD ... 0x026FD,        // 48   (1)     -
    0x02702 ... 0x02702,        // 49   (1)     -
    0x02705 ... 0x02705,        // 50   (1)     -
    0x02708 ... 0x0270D,        // 51   (6)     -
    0x0270F ... 0x0270F,        // 52   (1)     -
    0x02712 ... 0x02712,        // 53   (1)     -
    0x02714 ... 0x02714,        // 54   (1)     -
    0x02716 ... 0x02716,        // 55   (1)     -
    0x0271D ... 0x0271D,        // 56   (1)     -
    0x02721 ... 0x02721,        // 57   (1)     -
    0x02728 ... 0x02728,        // 58   (1)     -
    0x02733 ... 0x02734,        // 59   (2)     -
    0x02744 ... 0x02744,        // 60   (1)     -
    0x02747 ... 0x02747,        // 61   (1)     -
    0x0274C ... 0x0274C,        // 62   (1)     -
    0x0274E ... 0x0274E,        // 63   (1)     -
    0x02753 ... 0x02755,        // 64   (3)     -
    0x02757 ... 0x02757,        // 65   (1)     -
    0x02763 ... 0x02764,        // 66   (2)     -
    0x02795 ... 0x02797,        // 67   (3)     -
    0x027A1 ... 0x027A1,        // 68   (1)     -
    0x02934 ... 0x02935,        // 69   (2)     -
    0x02B05 ... 0x02B07,        // 70   (3)     -
    0x02B1B ... 0x02B1C,        // 71   (2)     -
    0x02B50 ... 0x02B50,        // 72   (1)     -
    0x02B55 ... 0x02B55,        // 73   (1)     -
    0x0303D ... 0x0303D,        // 74   (1)     -
    0x03297 ... 0x03297,        // 75   (1)     -
    0x03299 ... 0x03299,        // 76   (1)     -
    0x1F004 ... 0x1F004,        // 77   (1)     -
    0x1F0CF ... 0x1F0CF,        // 78   (1)     -
    0x1F170 ... 0x1F171,        // 79   (2)     -
    0x1F17E ... 0x1F17F,        // 80   (2)     -
    0x1F18E ... 0x1F18E,        // 81   (1)     -
    0x1F191 ... 0x1F19A,        // 82   (10)    -
    0x1F1E6 ... 0x1F1FF,        // 83   (26)    -   Флаги
    0x1F201 ... 0x1F202,        // 84   (2)     -
    0x1F21A ... 0x1F21A,        // 85   (1)     -
    0x1F22F ... 0x1F22F,        // 86   (1)     -
    0x1F232 ... 0x1F23A,        // 87   (9)     -
    0x1F250 ... 0x1F251,        // 88   (2)     -
    0x1F300 ... 0x1F321,        // 89   (34)    -
    0x1F324 ... 0x1F393,        // 90   (112)   -
    0x1F396 ... 0x1F397,        // 91   (2)     -
    0x1F399 ... 0x1F39B,        // 92   (3)     -
    0x1F39E ... 0x1F3F0,        // 93   (83)    -
    0x1F3F3 ... 0x1F3F5,        // 94   (3)     -
    0x1F3F7 ... 0x1F4FD,        // 95   (263)   -
    0x1F4FF ... 0x1F53D,        // 96   (63)    -
    0x1F549 ... 0x1F54E,        // 97   (6)     -
    0x1F550 ... 0x1F567,        // 98   (24)    -
    0x1F56F ... 0x1F570,        // 99   (2)     -
    0x1F573 ... 0x1F57A,        // 100  (8)     -
    0x1F587 ... 0x1F587,        // 101  (1)     -
    0x1F58A ... 0x1F58D,        // 102  (4)     -
    0x1F590 ... 0x1F590,        // 103  (1)     -
    0x1F595 ... 0x1F596,        // 104  (2)     -
    0x1F5A4 ... 0x1F5A5,        // 105  (2)     -
    0x1F5A8 ... 0x1F5A8,        // 106  (1)     -
    0x1F5B1 ... 0x1F5B2,        // 107  (2)     -
    0x1F5BC ... 0x1F5BC,        // 108  (1)     -
    0x1F5C2 ... 0x1F5C4,        // 109  (3)     -
    0x1F5D1 ... 0x1F5D3,        // 110  (3)     -
    0x1F5DC ... 0x1F5DE,        // 111  (3)     -
    0x1F5E1 ... 0x1F5E1,        // 112  (1)     -
    0x1F5E3 ... 0x1F5E3,        // 113  (1)     -
    0x1F5E8 ... 0x1F5E8,        // 114  (1)     -
    0x1F5EF ... 0x1F5EF,        // 115  (1)     -
    0x1F5F3 ... 0x1F5F3,        // 116  (1)     -
    0x1F5FA ... 0x1F64F,        // 117  (86)    -
    0x1F680 ... 0x1F6C5,        // 118  (70)    -
    0x1F6CB ... 0x1F6D2,        // 119  (8)     -
    0x1F6D5 ... 0x1F6D7,        // 120  (3)     -
    0x1F6DD ... 0x1F6E5,        // 121  (9)     -
    0x1F6E9 ... 0x1F6E9,        // 122  (1)     -
    0x1F6EB ... 0x1F6EC,        // 123  (2)     -
    0x1F6F0 ... 0x1F6F0,        // 124  (1)     -
    0x1F6F3 ... 0x1F6FC,        // 125  (10)    -
    0x1F7E0 ... 0x1F7EB,        // 126  (12)    -
    0x1F7F0 ... 0x1F7F0,        // 127  (1)     -
    0x1F90C ... 0x1F93A,        // 128  (47)    -
    0x1F93C ... 0x1F945,        // 129  (10)    -
    0x1F947 ... 0x1F9FF,        // 130  (185)   -
    0x1FA70 ... 0x1FA74,        // 131  (5)     -
    0x1FA78 ... 0x1FA7C,        // 132  (5)     -
    0x1FA80 ... 0x1FA86,        // 133  (7)     -
    0x1FA90 ... 0x1FAAC,        // 134  (29)    -
    0x1FAB0 ... 0x1FABA,        // 135  (11)    -
    0x1FAC0 ... 0x1FAC5,        // 136  (6)     -
    0x1FAD0 ... 0x1FAD9,        // 137  (10)    -
    0x1FAE0 ... 0x1FAE7,        // 138  (8)     -
    0x1FAF0 ... 0x1FAF6         // 139  (7)     -
]


final class Emoji: EmojiGeneratable {
    
    private let flag: FlagGeneratable
    
    //
    // TODO: - Logging info
    //
    init(flag service: FlagGeneratable = Flag()) {
        flag = service
        
        print("SERVICE\t\t😈\tEmoji")
    }
    
    deinit {
        print("SERVICE\t\t♻️\tEmoji")
    }
    
    
    ///
    /// Variation Selector-16
    /// Невидимый элемент кода, который указывает, что предыдущий символ должен отображаться в виде Эмоджи.
    /// Требуется только в том случае, если предыдущий символ по умолчанию имеет текстовое представление.
    ///
    private let VS16 = "\u{FE0F}"
    
    
    func makeSequence(for level: Sizeable) -> [String] {
        ///
        /// Создаем массив из всех эмоджи; из него будем доставать случайным образом эмоджи,
        /// чтобы эмоджи не повторялись, будем удалять его из массива.
        ///
        var emojiArray: [Int] = []
        unicodeEmojiList.forEach { emojiArray.append(contentsOf: $0) }
        guard level.size < emojiArray.count else { return [] }
        ///
        /// Создаем два массива один будет соответствовать игровому полю,
        /// в него будем складывать (два раза), на случайные позиции, выбранный эмоджи.
        ///
        /// Второй массив с индексами игрового поля, нужен для получение случайного индекса ячейки игрового поля,
        /// чтобы индексы не повторялись, будем удалять их из массива.
        ///
        /// Так как игрового поле - это квадрат со стороной level, то количество ячеек в квадрате = level^2
        ///
        var sequence = Array(repeating: "", count: (level.size * level.size))
        var sequenceIndexArray: [Int] = (0 ..< sequence.count).map { $0 }
        ///
        /// Уменьшаем число итераций в двое так как один и тот же эмоджи ставиться на две случайных позиции
        ///
        let end = sequence.count/2
        
        for _ in 0 ..< end {
            let emojiIndex = Int.random(in: 0 ..< emojiArray.count)
            if let scalar = UnicodeScalar(emojiArray[emojiIndex]) {
                var emoji = String(scalar)
                ///
                /// Если выбранный эмоджи из диапазона Флаги, то запускаем генератор случайных флагов
                /// Диапазон с флагами - 0x1F1E6 ... 0x1F1FF он же диапазон от 🇦️ до 🇿️
                ///
                if let unicodeScalar = emoji.unicodeScalars.first?.value, (0x1F1E6 ... 0x1F1FF).contains(unicodeScalar) {
                    emoji = getRandomEmojiFlag(of: sequence)
                }
                emoji += VS16
                
                var sequenceIndex = Int.random(in: 0 ..< sequenceIndexArray.count)
                var index = sequenceIndexArray[sequenceIndex]
                sequence[index] = emoji
                sequenceIndexArray.remove(at: sequenceIndex)
                
                sequenceIndex = Int.random(in: 0 ..< sequenceIndexArray.count)
                index = sequenceIndexArray[sequenceIndex]
                sequence[index] = emoji
                sequenceIndexArray.remove(at: sequenceIndex)
            }
            emojiArray.remove(at: emojiIndex)
        }
        return sequence
    }
    
    ///
    /// Если хотим избежать повторений, то необходимо убедиться в том, что количество доступных флагов больше чем уже собранная последовательность;
    /// Так как в нашей задаче один эмоджи ставиться на два место, то количество доступных флагов должно быть не меньше половины последовательности.
    ///
    /// Если повторение не нужно то можно передавать в функцию пустую последовательность.
    ///
    private func getRandomEmojiFlag(of outside: [String]) -> String {
        guard flag.count > outside.count/2 else { return "" }
        
        var emoji = ""
        repeat {
            emoji = flag.getRandomFlag()
        } while outside.contains(emoji)
        return emoji
    }
}
