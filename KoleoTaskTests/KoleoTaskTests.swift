//
//  KoleoTaskTests.swift
//  KoleoTaskTests
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import XCTest
@testable import KoleoTask

class KoleoTaskTests: XCTestCase {
    
    let client = KoleoClient.shared
    
    func getStations() {
        let getStationsExpectation = expectation(description: "getStations")
        client.getStations { (error, stations) in
            XCTAssertNotNil(stations)
            XCTAssertNil(error)
            getStationsExpectation.fulfill()
        }
        wait(for: [getStationsExpectation], timeout: 20)
    }

}
