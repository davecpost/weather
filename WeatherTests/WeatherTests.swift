//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by David Post on 2021-10-06.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let key: String = try! Configuration.value(for: "API_KEY")
        print(key)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
