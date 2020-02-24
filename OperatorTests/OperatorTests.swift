//
//  OperatorTests.swift
//  OperatorTests
//
//  Created by Farini on 2/23/20.
//  Copyright © 2020 Farini. All rights reserved.
//

import XCTest
@testable import Operator

class OperatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - URL Test
    
    func testURL_JavaScript_file() {
        
        let url = SJSController.javaScriptURL
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let string = String(data: data, encoding: .utf8) {
                    // Make sure string is not empty
                    XCTAssert(string.isEmpty == false)
                    print("=========================")
                    print("JavaScript file contents")
                    print("-------------------------\n\n")
                    print(string)
                }
            }
        }
        task.resume()
        // make sure the current request is the request
        XCTAssert(task.currentRequest == request)
    }
    
    // MARK: - Dictionary tests
    
    func testDecodingDictionaryWithTypo_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(Message.self, from: dictionaryWithTypo)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                // a typo in the message key
                XCTAssertEqual("message", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }

    func testDecodingDictionaryWithMissingKey_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(Message.self, from: dictionaryWithMissingKey)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("message", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    private let dictionaryWithTypo = Data("""
    {
        "id" : "X1",
        "messag": "progress",
        "progress": 21,
        "state": "state"
    }
    """.utf8)

    private let dictionaryWithMissingKey = Data("""
    {
        "id" : "X1",
        "progress": 21,
        "state": "state"
    }
    """.utf8)

}
