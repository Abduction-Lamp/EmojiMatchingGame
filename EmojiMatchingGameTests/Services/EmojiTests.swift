//
//  EmojiTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame


final class EmojiTests: XCTestCase {

    let emoji: EmojiGeneratable = Emoji()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testSequence() throws {
        Level.allCases.forEach { level in
            
            // Проверяем соответствует размер последовательности текущему уровню игры
            let sequence = emoji.sequence(for: level)
            XCTAssertEqual(sequence.count, level.size * level.size)
            
            // Проверяем emoji это или нет
            sequence.forEach { char in
                if char.unicodeScalars.count == 1 {
                    let isEmoji = char.unicodeScalars.first?.properties.isEmoji ?? false
                    XCTAssertTrue(isEmoji)
                    let isEmojiPresentation = char.unicodeScalars.first?.properties.isEmojiPresentation ?? false
                    XCTAssertTrue(isEmojiPresentation)
                } else if char.unicodeScalars.count > 1 {
                    let isEmoji = char.unicodeScalars.first?.properties.isEmoji ?? false
                    XCTAssertTrue(isEmoji)
                } else {
                    XCTFail()
                }
            }
            
            // Проверяем что в последовательности все emoji представленны ровно два раза
            var emojiCheckSum: [String: Int] = [:]
            sequence.forEach { str in
                if emojiCheckSum[str] == nil {
                    emojiCheckSum[str] = 1
                } else {
                    emojiCheckSum[str]? += 1
                }
            }
            XCTAssertEqual(emojiCheckSum.count, (level.size * level.size) / 2)
            emojiCheckSum.forEach { XCTAssertEqual($0.value, 2) }
            emojiCheckSum.removeAll()
        }
    }
}
