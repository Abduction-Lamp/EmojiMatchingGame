//
//  UIImageTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiMatchingGame

final class UIImageTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testImageColorChange() throws {
        let img = UIImage(systemName: "heart.fill")
        XCTAssertNotNil(img)
        
        let expression = img?.withColor(.red, size: nil)
        XCTAssertNotNil(expression)
        
        XCTAssertFalse(img === expression)
    }
}
