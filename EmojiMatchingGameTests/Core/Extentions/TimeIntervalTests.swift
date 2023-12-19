//
//  TimeIntervalTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 18.12.2023.
//

import XCTest
@testable import EmojiMatchingGame

final class TimeIntervalTests: XCTestCase {

    let hour        : TimeInterval = 3600
    let minute      : TimeInterval = 60
    let second      : TimeInterval = 1
    let millisecond : TimeInterval = 0.001
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testSimple_toString() throws {
        XCTAssertEqual("1:00:00,000", hour.toString())
        XCTAssertEqual("1:00,000", minute.toString())
        XCTAssertEqual("1,000", second.toString())
        XCTAssertEqual("0,001", millisecond.toString())
        XCTAssertEqual("0,000", TimeInterval.zero.toString())
    }
    
    func testComposite_toString() throws {
        var expression          : String
        var hourComposite       : TimeInterval
        var minuteComposite     : TimeInterval
        var secondComposite     : TimeInterval
        var millisecondComposite: TimeInterval
        var time                : TimeInterval
        
        expression           = "915:29:01,000"
        hourComposite        = 915 * hour
        minuteComposite      = 29 * minute
        secondComposite      = 1 * second
        millisecondComposite = .zero
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "27:37:59,100"
        hourComposite        = 27 * hour
        minuteComposite      = 37 * minute
        secondComposite      = 59 * second
        millisecondComposite = 100 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "3:04:05,060"
        hourComposite        = 3 * hour
        minuteComposite      = 4 * minute
        secondComposite      = 5 * second
        millisecondComposite = 60 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "15:09,999"
        hourComposite        = 0 * hour
        minuteComposite      = 15 * minute
        secondComposite      = 9 * second
        millisecondComposite = 999 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "7,123"
        hourComposite        = 0 * hour
        minuteComposite      = 0 * minute
        secondComposite      = 7 * second
        millisecondComposite = 123 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "49,009"
        hourComposite        = 0 * hour
        minuteComposite      = 0 * minute
        secondComposite      = 49 * second
        millisecondComposite = 9 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "0,080"
        hourComposite        = 0 * hour
        minuteComposite      = 0 * minute
        secondComposite      = 0 * second
        millisecondComposite = 80 * millisecond
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
        
        expression           = "0,000"
        hourComposite        = 0 * hour
        minuteComposite      = 0 * minute
        secondComposite      = 0 * second
        millisecondComposite = 0.000499999
        time = hourComposite + minuteComposite + secondComposite + millisecondComposite
        XCTAssertEqual(expression, time.toString())
    }
}
