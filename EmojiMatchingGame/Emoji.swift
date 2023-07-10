//
//  Emoji.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.07.2023.
//

import Foundation



fileprivate let unicodeEmojiList = [
    0x0231A ... 0x0231B,        // 0    (2)     -
    0x023E9 ... 0x023F3,        // 1    (11)    -
    0x02614 ... 0x02615,        // 2    (2)     -
    0x02648 ... 0x02653,        // 3    (12)    -
    0x026AA ... 0x026AB,        // 4    (2)     -
    0x026BD ... 0x026BE,        // 5    (2)     -
    0x026C4 ... 0x026C5,        // 6    (2)     -
    0x026CE ... 0x026CF,        // 7    (2)     -
    0x026FD ... 0x026FD,        // 8    (1)     -
    0x02705 ... 0x02705,        // 9    (1)     -
    0x0270A ... 0x0270D,        // 10   (4)     -
    0x02728 ... 0x02728,        // 11   (1)     -
    0x0274C ... 0x0274C,        // 12   (1)     -
    0x0274E ... 0x0274E,        // 13   (1)     -
    0x02753 ... 0x02755,        // 14   (3)     -
    0x02757 ... 0x02757,        // 15   (1)     -
    0x02795 ... 0x02797,        // 16   (3)     -
    0x02B05 ... 0x02B07,        // 17   (3)     -
    0x02B1B ... 0x02B1C,        // 18   (2)     -
    0x02B50 ... 0x02B50,        // 19   (1)     -
    0x02B55 ... 0x02B55,        // 20   (1)     -
    0x1F004 ... 0x1F004,        // 21   (1)     -
    0x1F0CF ... 0x1F0CF,        // 22   (1)     -
    0x1F18E ... 0x1F18E,        // 23   (1)     -
    0x1F191 ... 0x1F19A,        // 24   (10)    -
    0x1F1E6 ... 0x1F1FF,        // 25   (26)    -
    0x1F201 ... 0x1F202,        // 26   (2)     -
    0x1F21A ... 0x1F21A,        // 27   (1)     -
    0x1F22F ... 0x1F22F,        // 28   (1)     -
    0x1F232 ... 0x1F23A,        // 29   (9)     -
    0x1F250 ... 0x1F251,        // 30   (2)     -
    0x1F300 ... 0x1F321,        // 31   (34)    -
    0x1F324 ... 0x1F393,        // 32   (112)   -
    0x1F396 ... 0x1F397,        // 33   (2)     -
    0x1F399 ... 0x1F39B,        // 34   (3)     -
    0x1F39E ... 0x1F3F0,        // 35   (83)    -
    0x1F3F3 ... 0x1F3F5,        // 36   (3)     -
    0x1F3F7 ... 0x1F4FD,        // 37   (263)   -
    0x1F4FF ... 0x1F53D,        // 38   (63)    -
    0x1F549 ... 0x1F54E,        // 39   (6)     -
    0x1F550 ... 0x1F567,        // 40   (24)    -
    0x1F56F ... 0x1F570,        // 41   (2)     -
    0x1F573 ... 0x1F57A,        // 42   (8)     -
    0x1F587 ... 0x1F587,        // 43   (1)     -
    0x1F58A ... 0x1F58D,        // 44   (4)     -
    0x1F590 ... 0x1F590,        // 45   (1)     -
    0x1F595 ... 0x1F596,        // 46   (2)     -
    0x1F5A4 ... 0x1F5A5,        // 47   (2)     -
    0x1F5A8 ... 0x1F5A8,        // 48   (1)     -
    0x1F5B1 ... 0x1F5B2,        // 49   (2)     -
    0x1F5BC ... 0x1F5BC,        // 50   (1)     -
    0x1F5C2 ... 0x1F5C4,        // 51   (3)     -
    0x1F5D1 ... 0x1F5D3,        // 52   (3)     -
    0x1F5DC ... 0x1F5DE,        // 53   (3)     -
    0x1F5E1 ... 0x1F5E1,        // 54   (1)     -
    0x1F5E3 ... 0x1F5E3,        // 55   (1)     -
    0x1F5E8 ... 0x1F5E8,        // 56   (1)     -
    0x1F5EF ... 0x1F5EF,        // 57   (1)     -
    0x1F5F3 ... 0x1F5F3,        // 58   (1)     -
    0x1F5FA ... 0x1F64F,        // 59   (86)    -
    0x1F680 ... 0x1F6C5,        // 60   (70)    -
    0x1F6CB ... 0x1F6D2,        // 61   (8)     -
    0x1F6D5 ... 0x1F6D7,        // 62   (3)     -
    0x1F6DD ... 0x1F6E5,        // 63   (9)     -
    0x1F6E9 ... 0x1F6E9,        // 64   (1)     -
    0x1F6EB ... 0x1F6EC,        // 65   (2)     -
    0x1F6F0 ... 0x1F6F0,        // 66   (1)     -
    0x1F6F3 ... 0x1F6FC,        // 67   (10)    -
    0x1F7E0 ... 0x1F7EB,        // 68   (12)    -
    0x1F7F0 ... 0x1F7F0,        // 69   (1)     -
    0x1F90C ... 0x1F93A,        // 70   (47)    -
    0x1F93C ... 0x1F945,        // 71   (10)    -
    0x1F947 ... 0x1F9FF,        // 72   (185)   -
    0x1FA70 ... 0x1FA74,        // 73   (5)     -
    0x1FA78 ... 0x1FA7C,        // 74   (5)     -
    0x1FA80 ... 0x1FA86,        // 75   (7)     -
    0x1FA90 ... 0x1FAAC,        // 76   (29)    -
    0x1FAB0 ... 0x1FABA,        // 77   (11)    -
    0x1FAC0 ... 0x1FAC5,        // 78   (6)     -
    0x1FAD0 ... 0x1FAD9,        // 79   (10)    -
    0x1FAE0 ... 0x1FAE7,        // 80   (8)     -
    0x1FAF0 ... 0x1FAF6         // 81   (7)     -
]


final class Emoji {
    
    func makeSequence(for level: Level) -> [String] {
        ///
        /// Создаем массив из всех эмоджи; из него будем достовать случайным образом эмоджи,
        /// чтобы эмоджи не повторялисль, будем удалять его из массива.
        ///
        var emojiArray: [Int] = []
        unicodeEmojiList.forEach { emojiArray.append(contentsOf: $0) }
        
        ///
        /// Создаем два массива один будет соответствовать игровому полю,
        /// в него будем складывать (два раза), на случайные позиции, выбранный эмоджи.
        ///
        /// Второй массив с индексами игового поля, нужен для получение случайного индекса ячейки игрового поля,
        /// чтобы индексы не повторялисль, будем удалять их из массива.
        ///
        var sequence = Array(repeating: "", count: (2 * level.rawValue))
        var sequenceIndexArray: [Int] = (0 ..< (2 * level.rawValue)).map { $0 }
        
        for _ in 0 ..< level.rawValue {
            let emojiIndex = Int.random(in: 0 ..< emojiArray.count)
            if let scalar = UnicodeScalar(emojiArray[emojiIndex]) {
                var sequenceIndex = Int.random(in: 0 ..< sequenceIndexArray.count)
                var index = sequenceIndexArray[sequenceIndex]
                sequence[index] = String(scalar)
                sequenceIndexArray.remove(at: sequenceIndex)
                
                sequenceIndex = Int.random(in: 0 ..< sequenceIndexArray.count)
                index = sequenceIndexArray[sequenceIndex]
                sequence[index] = String(scalar)
                sequenceIndexArray.remove(at: sequenceIndex)
            }
            emojiArray.remove(at: emojiIndex)
        }
        return sequence
    }
}
