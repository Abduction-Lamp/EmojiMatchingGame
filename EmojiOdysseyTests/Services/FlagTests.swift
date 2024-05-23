//
//  FlagTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiOdyssey

final class FlagTests: XCTestCase {

    let flag: FlagGeneratable = Flag()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testMake() throws {
        let mokcFlag = ["🇯🇵", "🇫🇮", "🇷🇺", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "🇬🇧", "🇪🇺", "🇫🇷", "🇺🇸", "🇦🇶", "🏴‍☠️", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "🏳️‍🌈", "🏳️‍⚧️", "🇺🇳"]
        let mokcTag = ["JP", "FI", "RU", "2", "GB", "EU", "FR", "US", "AQ", "0", "1", "3", "4", "5", "UN"]
        
        XCTAssertEqual(mokcFlag.count, mokcTag.count)
        mokcTag.forEach { XCTAssertTrue(mokcFlag.contains(flag.make($0))) }
    }
    
    func testAll() throws {
        XCTAssertEqual(flag.count, flag.all().count)
    }
    
    func testRandom() throws {
        let rand = flag.random()
        XCTAssertTrue(flag.all().contains(rand))
    }
}
