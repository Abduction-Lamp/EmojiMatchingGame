//
//  UIColorTests.swift
//  EmojiMatchingGameTests
//
//  Created by Vladimir Lesnykh on 19.12.2023.
//

import XCTest
@testable import EmojiOdyssey

final class UIColorTests: XCTestCase {
    
    let black  = "#000000"
    let white  = "#FFFFFF"
    let red    = "#ff0000"
    let green  = "#00ff00"
    let blue   = "#0000ff"
    let yellow = "#FFFF00"
    let gray   = "#7F7F7F"
    let clear  = "#000000"
    
    let alpha0  : CGFloat = 0.0
    let alpha025: CGFloat = 0.25
    let alpha05 : CGFloat = 0.5
    let alpha075: CGFloat = 0.75
    let alpha1  : CGFloat = 1.0

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testVarColor() throws {
        XCTAssertEqual(black.uppercased(),  UIColor.black.hex)
        XCTAssertEqual(white.uppercased(),  UIColor.white.hex)
        XCTAssertEqual(red.uppercased(),    UIColor.red.hex)
        XCTAssertEqual(green.uppercased(),  UIColor.green.hex)
        XCTAssertEqual(blue.uppercased(),   UIColor.blue.hex)
        XCTAssertEqual(yellow.uppercased(), UIColor.yellow.hex)
        XCTAssertEqual(gray.uppercased(),   UIColor.gray.hex)
        XCTAssertEqual(clear.uppercased(),  UIColor.clear.hex)
        
        XCTAssertEqual(alpha1,   UIColor.black.alpha)
        XCTAssertEqual(alpha1,   UIColor.white.alpha)
        XCTAssertEqual(alpha0,   UIColor.clear.alpha)
        XCTAssertEqual(alpha0,   UIColor.red.withAlphaComponent(0).alpha)
        XCTAssertEqual(alpha0,   UIColor.green.withAlphaComponent(0).alpha)
        XCTAssertEqual(alpha025, UIColor.blue.withAlphaComponent(0.25).alpha)
        XCTAssertEqual(alpha05,  UIColor.yellow.withAlphaComponent(0.5).alpha)
        XCTAssertEqual(alpha075, UIColor.gray.withAlphaComponent(0.75).alpha)
    }
    
    func testConvenienceInitHexString() throws {
        let blackColor: UIColor = .black
        let whiteColor: UIColor = .white
        let grayColor:  UIColor = .gray
        
        var expression = UIColor(hex: black)
        XCTAssertNotNil(expression)
        XCTAssertEqual(blackColor.hex, expression?.hex)

        expression = UIColor(hex: white)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        
        expression = UIColor(hex: gray)
        XCTAssertNotNil(expression)
        XCTAssertEqual(grayColor.hex, expression?.hex)
        
        // MARK: Без префикса #
        let blackWithoutSharp  = "000000"
        let whiteWithoutSharp  = "FFFFFF"
        let grayWithoutSharp   = "7F7F7F"
        
        expression = UIColor(hex: blackWithoutSharp)
        XCTAssertNotNil(expression)
        XCTAssertEqual(blackColor.hex, expression?.hex)
        XCTAssertEqual(blackColor.alpha, expression?.alpha)

        expression = UIColor(hex: whiteWithoutSharp)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        XCTAssertEqual(whiteColor.alpha, expression?.alpha)
        
        expression = UIColor(hex: grayWithoutSharp)
        XCTAssertNotNil(expression)
        XCTAssertEqual(grayColor.hex, expression?.hex)
        XCTAssertEqual(grayColor.alpha, expression?.alpha)
        
        // MARK: Недопустимая строка
        expression = UIColor(hex: "QWERTY1")
        XCTAssertNil(expression)
        expression = UIColor(hex: "FF  00 C")
        XCTAssertNil(expression)
        
        // MARK: С альфа каналом
        expression = UIColor(hex: blackWithoutSharp, alpha: 0)
        XCTAssertNotNil(expression)
        XCTAssertEqual(blackColor.hex, expression?.hex)
        XCTAssertEqual(blackColor.withAlphaComponent(0).alpha, expression?.alpha)

        expression = UIColor(hex: whiteWithoutSharp, alpha: 0.5)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        XCTAssertEqual(whiteColor.withAlphaComponent(0.5).alpha, expression?.alpha)
        
        expression = UIColor(hex: grayWithoutSharp, alpha: -1)
        XCTAssertNotNil(expression)
        XCTAssertEqual(grayColor.hex, expression?.hex)
        XCTAssertEqual(grayColor.alpha, expression?.alpha)
        
        // MARK: Иницилизатор с коротким кодом
        let shortBlack = "#000"
        let shortWhite = "FFF"
        let short = "ABC"
        expression = UIColor(hex: shortBlack, alpha: -1)
        XCTAssertNotNil(expression)
        XCTAssertEqual(blackColor.hex, expression?.hex)
        XCTAssertEqual(blackColor.alpha, expression?.alpha)

        expression = UIColor(hex: shortWhite, alpha: 0.5)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        XCTAssertEqual(whiteColor.withAlphaComponent(0.5).alpha, expression?.alpha)

        expression = UIColor(hex: short)
        XCTAssertNotNil(expression)
        XCTAssertEqual(UIColor(hex: "AABBCC")?.hex, expression?.hex)
        
        // MARK: Иницилизатор с длинным кодом
        let longBlack = "#000000FF"
        let longWhite = "FFFFFF00"
   
        expression = UIColor(hex: longBlack)
        XCTAssertNotNil(expression)
        XCTAssertEqual(blackColor.hex, expression?.hex)
        XCTAssertEqual(blackColor.alpha, expression?.alpha)
        
        expression = UIColor(hex: longWhite)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        XCTAssertEqual(whiteColor.withAlphaComponent(0).alpha, expression?.alpha)
        
        expression = UIColor(hex: longWhite, alpha: 1)
        XCTAssertNotNil(expression)
        XCTAssertEqual(whiteColor.hex, expression?.hex)
        XCTAssertEqual(whiteColor.withAlphaComponent(0).alpha, expression?.alpha)

        // MARK: Иницилизатор с ошибкой
        expression = UIColor(hex: "FFFF", alpha: 1)
        XCTAssertNil(expression)
    }
    
    func testConvenienceInitHexInt() throws {
        let blackColor: Int = 0x000000
        let whiteColor: Int = 0xFFFFFF
        let grayColor:  Int = 0x7F7F7F
        
        var expression = UIColor(hex: blackColor)
        XCTAssertNotNil(expression)
        XCTAssertEqual(black.uppercased(), expression?.hex)

        expression = UIColor(hex: whiteColor)
        XCTAssertNotNil(expression)
        XCTAssertEqual(white.uppercased(), expression?.hex)
        
        expression = UIColor(hex: grayColor)
        XCTAssertNotNil(expression)
        XCTAssertEqual(gray.uppercased(), expression?.hex)
        
        // MARK: Недопустимая строка
        expression = UIColor(hex: -0x000001)
        XCTAssertNil(expression)
        expression = UIColor(hex: 0x1FFFFFF)
        XCTAssertNil(expression)
        
        // MARK: С альфа каналом
        expression = UIColor(hex: blackColor, alpha: 0)
        XCTAssertNotNil(expression)
        XCTAssertEqual(UIColor.black.withAlphaComponent(0).hex, expression?.hex)
        XCTAssertEqual(UIColor.black.withAlphaComponent(0).alpha, expression?.alpha)

        expression = UIColor(hex: whiteColor, alpha: 0.5)
        XCTAssertNotNil(expression)
        XCTAssertEqual(UIColor.white.withAlphaComponent(0.5).hex, expression?.hex)
        XCTAssertEqual(UIColor.white.withAlphaComponent(0.5).alpha, expression?.alpha)
        
        expression = UIColor(hex: grayColor, alpha: -1)
        XCTAssertNotNil(expression)
        XCTAssertEqual(UIColor.gray.hex, expression?.hex)
        XCTAssertEqual(UIColor.gray.alpha, expression?.alpha)
    }
}
