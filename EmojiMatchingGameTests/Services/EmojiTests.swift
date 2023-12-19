//
//  EmojiTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame


final class EmojiTests: XCTestCase {

    let emoji = Emoji()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testMakeSequence() throws {
        Level.allCases.forEach { level in
                
            let sequence = emoji.makeSequence(for: level)
            XCTAssertEqual(sequence.count, level.size * level.size)
            
            var emojiCheckSum: [String: Int] = [:]
            sequence.forEach { str in
                let isEmoji = str.contains { $0.unicodeScalars.first?.properties.isEmoji ?? false }
                XCTAssertTrue(isEmoji)
                
                if emojiCheckSum[str] == nil {
                    emojiCheckSum[str] = 1
                } else {
                    emojiCheckSum[str]? += 1
                }
            }
            XCTAssertEqual(emojiCheckSum.count, level.size * level.size / 2)
            emojiCheckSum.forEach { XCTAssertEqual($0.value, 2) }
            emojiCheckSum.removeAll()
        }
    }
}
