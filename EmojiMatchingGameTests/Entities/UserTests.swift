//
//  UserTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame

final class UserTests: XCTestCase {

    let user = User.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        user.clear()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        user.clear()
    }

    func testInitExample() throws {
        XCTAssertEqual(user.startLevel.description, Level.one.description)
        XCTAssertEqual(user.unlockLevel.description, Level.one.description)
        XCTAssertEqual(user.bestResults.count, 0)
        Level.allCases.forEach { level in
            XCTAssertNil(user.getBestResult(for: level))
        }
    }
    
    func testUnlockLevel() throws {
        XCTAssertEqual(user.unlockLevel.description, Level.one.description)
        user.unlock()
        XCTAssertEqual(user.unlockLevel.description, Level.two.description)
        user.unlock()
        user.unlock()
        XCTAssertEqual(user.unlockLevel.description, Level.four.description)
    }
    
    
    func testSetUnlockLevel() throws {
        let newUnlockLevel: Level = .six
        XCTAssertEqual(user.unlockLevel.description, Level.one.description)
        user.unlockLevel = newUnlockLevel
        XCTAssertEqual(user.unlockLevel.description, newUnlockLevel.description)
    }
    
    func testSetStartLevel() throws {
        let newStartLevel: Level = .six
        XCTAssertEqual(user.startLevel.description, Level.one.description)
        XCTAssertEqual(user.unlockLevel.description, Level.one.description)
        user.startLevel = newStartLevel
        XCTAssertNotEqual(user.startLevel.description, newStartLevel.description)
        XCTAssertEqual(user.startLevel.description, Level.one.description)
        
        user.unlockLevel = newStartLevel
        user.startLevel = newStartLevel
        XCTAssertEqual(user.startLevel.description, newStartLevel.description)
    }
    
    func testSetBestResult() throws {
        let best1: User.BestResult = User.BestResult(time: 10, taps: 10)
        let best2: User.BestResult = User.BestResult(time: 100, taps: 1)
        let best3: User.BestResult = User.BestResult(time: 9, taps: 10)
        let best4: User.BestResult = User.BestResult(time: 9, taps: 9)
        
        XCTAssertEqual(user.bestResults.count, 0)
        Level.allCases.forEach { level in
            XCTAssertNil(user.getBestResult(for: level))
        }
        
        let one = Level.one
        let two = Level.two
        let six = Level.six
        
        user.setBestResult(for: one, result: best1)
        XCTAssertEqual(user.bestResults.count, 1)
        
        user.setBestResult(for: two, result: best1)
        XCTAssertEqual(user.bestResults.count, 2)
        user.setBestResult(for: two, result: best1)
        XCTAssertEqual(user.bestResults.count, 2)
        
        XCTAssertEqual(user.bestResults[one.description], best1)
        XCTAssertEqual(user.bestResults[two.description], best1)
        XCTAssertNil(user.bestResults["qqq"])
        
        XCTAssertEqual(user.getBestResult(for: one), best1)
        XCTAssertEqual(user.getBestResult(for: two), best1)
        
        user.setBestResult(for: six, result: best1)
        XCTAssertEqual(user.bestResults.count, 3)
        XCTAssertEqual(user.getBestResult(for: six), best1)
        user.setBestResult(for: six, result: best2)
        XCTAssertNotEqual(user.getBestResult(for: six), best2)
        XCTAssertEqual(user.getBestResult(for: six), best1)
        user.setBestResult(for: six, result: best3)
        XCTAssertNotEqual(user.getBestResult(for: six), best2)
        XCTAssertEqual(user.getBestResult(for: six), best3)
        user.setBestResult(for: six, result: best4)
        XCTAssertNotEqual(user.getBestResult(for: six), best3)
        XCTAssertEqual(user.getBestResult(for: six), best4)
    }
    
    func testFetch() throws {
        XCTAssertEqual(user.startLevel.description, Level.one.description)
        XCTAssertEqual(user.unlockLevel.description, Level.one.description)
        XCTAssertEqual(user.bestResults.count, 0)
        Level.allCases.forEach { level in
            XCTAssertNil(user.getBestResult(for: level))
        }
        
        let unlockLevel = Level.six
        let startLevel = Level.five
        
        let result1 = User.BestResult.init(time: 1, taps: 1)
        let result2 = User.BestResult.init(time: 2, taps: 2)
        let result3 = User.BestResult.init(time: 3, taps: 3)
        let result4 = User.BestResult.init(time: 4, taps: 4)
        let result5 = User.BestResult.init(time: 5, taps: 5)
        user.unlockLevel = unlockLevel
        user.startLevel = startLevel
        
        user.setBestResult(for: Level.one, result:   result1)
        user.setBestResult(for: Level.two, result:   result2)
        user.setBestResult(for: Level.three, result: result3)
        user.setBestResult(for: Level.four, result:  result4)
        user.setBestResult(for: Level.five, result:  result5)
        
        user.fetch()
        
        XCTAssertEqual(user.startLevel.description, startLevel.description)
        XCTAssertEqual(user.unlockLevel.description, unlockLevel.description)
        XCTAssertEqual(user.bestResults.count, 5)
        Level.allCases.forEach { level in
            if level != .six {
                XCTAssertNotNil(user.getBestResult(for: level))
                XCTAssertNotNil(user.bestResults[level.description])
            } else {
                XCTAssertNil(user.getBestResult(for: level))
                XCTAssertNil(user.bestResults[level.description])
            }
        }
        
        XCTAssertEqual(user.getBestResult(for: Level.one), result1)
        XCTAssertEqual(user.getBestResult(for: Level.two), result2)
        XCTAssertEqual(user.getBestResult(for: Level.three), result3)
        XCTAssertEqual(user.getBestResult(for: Level.four), result4)
        XCTAssertEqual(user.getBestResult(for: Level.five), result5)
        XCTAssertNil(user.getBestResult(for: Level.six))
    }
}
