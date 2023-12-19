//
//  LevelTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame

final class LevelTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testIndex() throws {
        XCTAssertEqual(Level.one.index,   0)
        XCTAssertEqual(Level.two.index,   1)
        XCTAssertEqual(Level.three.index, 2)
        XCTAssertEqual(Level.four.index,  3)
        XCTAssertEqual(Level.five.index,  4)
        XCTAssertEqual(Level.six.index,   5)
    }
    
    func testSize() throws {
        let multiplier = 2
        
        Level.allCases.forEach { level in
            let expression = (level.index + 1) * multiplier
            XCTAssertEqual(level.size, (expression))
        }
    }
    
    func testDescription() throws {
        XCTAssertEqual(Level.one.description,   "one")
        XCTAssertEqual(Level.two.description,   "two")
        XCTAssertEqual(Level.three.description, "three")
        XCTAssertEqual(Level.four.description,  "four")
        XCTAssertEqual(Level.five.description,  "five")
        XCTAssertEqual(Level.six.description,   "six")
    }
    
    func testNext() throws {
        XCTAssertEqual(Level.one.next().description, Level.two.description)
        XCTAssertEqual(Level.two.next().description, Level.three.description)
        XCTAssertEqual(Level.three.next().description, Level.four.description)
        XCTAssertEqual(Level.four.next().description, Level.five.description)
        XCTAssertEqual(Level.five.next().description, Level.six.description)
        XCTAssertEqual(Level.six.next().description, Level.six.description)
    }
    
    func testInitRawValue() throws {
        
        Level.allCases.forEach { level in
            let new = Level(rawValue: level.index)
            XCTAssertNotNil(new)
            XCTAssertEqual(new?.description, level.description)
            XCTAssertEqual(new?.index, level.index)
            XCTAssertEqual(new?.size, level.size)
        }
        
        var new = Level(rawValue: 1000)
        XCTAssertNil(new)
        new = Level(rawValue: -1)
        XCTAssertNil(new)
        new = Level(rawValue: Level.allCases.count)
        XCTAssertNil(new)
    }
}
