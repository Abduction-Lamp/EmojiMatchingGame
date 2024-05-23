//
//  UIFontTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiOdyssey

final class UIFontTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testMonospacedDigitSystemFont() throws {
        let style = UIFont.TextStyle.headline
        let weight = UIFont.Weight.bold
        let font = UIFont.monospacedDigitSystemFont(forTextStyle: style, weight: weight)
        XCTAssertEqual(font.fontName, UIFont.monospacedDigitSystemFont(ofSize: style.size, weight: weight).fontName)
    }
    
    func testFontHeight() throws {
        let font = UIFont.systemFont(ofSize: 16)
        XCTAssertEqual(font.height, font.lineHeight.rounded(.up))
    }
    
    func testItalicFont() throws {
        let regularFont = UIFont.systemFont(ofSize: 14)
        let italicFont = regularFont.italic(on: true)
        XCTAssertTrue(italicFont.fontDescriptor.symbolicTraits.contains(.traitItalic))
        XCTAssertEqual(regularFont.lineHeight, italicFont.lineHeight)
    }
    
    func testNonItalicFont() throws {
        let italicFont = UIFont.italicSystemFont(ofSize: 14)
        let regularFont = italicFont.italic(on: false)
        XCTAssertFalse(regularFont.fontDescriptor.symbolicTraits.contains(.traitItalic))
        XCTAssertEqual(regularFont.lineHeight, italicFont.lineHeight)
    }
    
    func testBoldFont() throws {
        let regularFont = UIFont.systemFont(ofSize: 14)
        let boldFont = regularFont.bold(on: true)
        XCTAssertTrue(boldFont.fontDescriptor.symbolicTraits.contains(.traitBold))
        XCTAssertEqual(regularFont.lineHeight, boldFont.lineHeight)
    }
    
    func testNonBoldFont() throws {
        let boldFont = UIFont.boldSystemFont(ofSize: 14)
        let regularFont = boldFont.bold(on: false)
        XCTAssertFalse(regularFont.fontDescriptor.symbolicTraits.contains(.traitBold))
        XCTAssertEqual(regularFont.lineHeight, boldFont.lineHeight)
    }
    
    func testTextStyleSize() throws {
        let styles: [UIFont.TextStyle] = [
            .largeTitle, .title1, .title2, .title3, .headline,
            .body, .callout, .subheadline, .footnote, .caption1, .caption2
        ]
        
        for style in styles {
            XCTAssertEqual(style.size, UIFont.preferredFont(forTextStyle: style).pointSize)
        }
    }
}
