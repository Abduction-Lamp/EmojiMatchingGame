//
//  AppearanceTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame

final class AppearanceTests: XCTestCase {

    let appearance = Appearance.shared
    var expectation: XCTestExpectation!

    
    override func setUpWithError() throws {
        try super.setUpWithError()
        expectation = XCTestExpectation(description: "[ Appearance > Observer ]")
        appearance.clear()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        appearance.clear()
        appearance.subscribers.removeAll()
        expectation = nil
    }

    func testInitExample() throws {
        XCTAssertEqual(appearance.mode, Design.Default.appearance.mode)
        XCTAssertEqual(appearance.color.hex, Design.Default.appearance.color.hex)
        XCTAssertEqual(appearance.animated, Design.Default.appearance.animated)
        XCTAssertEqual(appearance.sound, Design.Default.appearance.sound)
        XCTAssertEqual(appearance.volume, Design.Default.appearance.volume)
    }
    
    func testSetFetchClean() throws {
        XCTAssertEqual(appearance.color.hex, Design.Default.appearance.color.hex)
        appearance.color = .red
        XCTAssertEqual(appearance.color.hex, UIColor.red.hex)
        
        XCTAssertEqual(appearance.animated, Design.Default.appearance.animated)
        appearance.animated = false
        XCTAssertFalse(appearance.animated)
        
        XCTAssertEqual(appearance.mode, Design.Default.appearance.mode)
        appearance.mode = .dark
        XCTAssertEqual(appearance.mode, UIUserInterfaceStyle.dark)
        
        XCTAssertEqual(appearance.volume, Design.Default.appearance.volume)
        appearance.volume = 0.5
        XCTAssertEqual(appearance.volume, 0.5)
        
        appearance.sound = false
        XCTAssertFalse(appearance.sound)
        
        
        appearance.fetch()
        XCTAssertEqual(appearance.mode, UIUserInterfaceStyle.dark)
        XCTAssertEqual(appearance.color.hex, UIColor.red.hex)
        XCTAssertFalse(appearance.animated)
        XCTAssertFalse(appearance.sound)
        XCTAssertEqual(appearance.volume, 0.5)
        
        appearance.clear()
        XCTAssertEqual(appearance.mode, Design.Default.appearance.mode)
        XCTAssertEqual(appearance.color.hex, Design.Default.appearance.color.hex)
        XCTAssertEqual(appearance.animated, Design.Default.appearance.animated)
        XCTAssertEqual(appearance.sound, Design.Default.appearance.sound)
        XCTAssertEqual(appearance.volume, Design.Default.appearance.volume)
    }
    
    func testObserver() throws {
        let subscriber1 = SubscriberTestClass()
        let subscriber2 = SubscriberTestClass()
        let subscriber3 = SubscriberTestClass()
        
        appearance.register(subscriber1)
        appearance.register(subscriber2)
        appearance.register(subscriber3)
        
        XCTAssertFalse(subscriber1.updateCalled)
        XCTAssertFalse(subscriber2.updateCalled)
        XCTAssertFalse(subscriber3.updateCalled)
        XCTAssertEqual(appearance.subscribers.count, 3)
        
        let newColor: UIColor = appearance.color.hex == UIColor.black.hex ? UIColor.white : UIColor.black
        appearance.color = newColor
        XCTAssertEqual(appearance.color.hex, newColor.hex)
        XCTAssertTrue(subscriber1.updateCalled)
        XCTAssertTrue(subscriber2.updateCalled)
        XCTAssertTrue(subscriber3.updateCalled)
        
        appearance.unsubscribe(subscriber1)
        XCTAssertEqual(appearance.subscribers.count, 2)
        appearance.unsubscribe(subscriber2)
        XCTAssertEqual(appearance.subscribers.count, 1)
        appearance.unsubscribe(subscriber3)
        XCTAssertEqual(appearance.subscribers.count, 0)
    }
    
    
    private class SubscriberTestClass: Subscriber {
        
        public var updateCalled = false
        
        func update() {
            updateCalled = true
        }
    }
}
