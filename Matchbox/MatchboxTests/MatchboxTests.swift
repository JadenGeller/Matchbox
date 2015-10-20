//
//  MatchboxTests.swift
//  MatchboxTests
//
//  Created by Jaden Geller on 10/19/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Matchbox
import Parsley

class MatchboxTests: XCTestCase {
    
    func testMatchInitializeString() {
        let stream = TextStream("Hello")
        var greeting: String!
        
        if stream ->> greeting {
            XCTAssertEqual("Hello", greeting)
        } else {
            XCTFail(stream.error!.description)
        }
    }
    
    func testMatchInitializeMultipleSpacedStrings() {
        let stream = TextStream("Hello world")
        var greeting: String!
        var place: String!
        
        if stream ->> greeting ->> place {
            XCTAssertEqual("Hello", greeting)
            XCTAssertEqual("world", place)
        } else {
            XCTFail(stream.error!.description)
        }
    }
    
    func testMatchVerifyString() {
        let stream = TextStream("Jaden Geller")
        
        if !(stream ->> "Jaden" ->> "Geller") {
            XCTFail(stream.error!.description)
        }
    }
    
    func testMatchIncludeWhitespace() {
        let stream = TextStream("Jaden Geller", ignoreWhitespace: false)
        
        if (stream ->> "Jaden" ->> "Geller") {
            XCTFail("Expected whitespace to be considered.")
        }
    }
    
    func testMatchVerifyStringFail() {
        let stream = TextStream("Jaden Geller cool")
        
        if stream ->> "Jaden" ->> "Geller" ->> "ewww" {
            XCTFail()
        }
    }
    
    func testMatchVerifyInitializeNumber() {
        let stream = TextStream("123 0456 00789")
        var num: Int!
        if stream ->> 123 ->> num ->> 789 {
            XCTAssertEqual(456, num)
        } else {
            XCTFail(stream.error!.description)
        }
    }
    
    func testMatchVerifyInitializeFloatingNumber() {
        let stream = TextStream("-000.35100 053.532 5")
        var num: Float!
        var num2: Float!
        if stream ->> -0.351 ->> num ->> num2 {
            XCTAssertEqual(53.532, num)
            XCTAssertEqual(5, num2)
        } else {
            XCTFail(stream.error!.description)
        }
    }
    
    func testCommandlineArguments() {
        let stream = TextStream("myProgram fileName 340 59")
        var filename: String!
        var width: Int!
        var height: Int!
        if stream ->> String.self ->> filename ->> width ->> height {
            XCTAssertEqual("fileName", filename)
            XCTAssertEqual(340, width)
            XCTAssertEqual(59, height)
        } else {
            XCTFail(stream.error!.description)
        }
    }

}
