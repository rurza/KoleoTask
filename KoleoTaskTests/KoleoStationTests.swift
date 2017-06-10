//
//  KoleoStationTests.swift
//  KoleoTask
//
//  Created by rurza on 10/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import XCTest

class KoleoStationTests: XCTestCase {
    
    var json = Array<[String:Any]>()

    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "stations", withExtension: "json")//path(forResource: "stations", ofType: "json")
        do {
            let data = try Data.init(contentsOf: url!)
            json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Array<[String:Any]>
        } catch {
            print(error)
        }
    }
    
    func testInitialization() {
        let station = Station(jsonDict: json.first!)
        XCTAssertNotNil(station)
    }
    
    func testLazyInitializationOfAnnotation() {
        let station = Station(jsonDict: json.first!)
        let annotation = station?.annotation
        XCTAssertNotNil(annotation)
    }
    
    
    func testEquality() {
        let station1 = Station(jsonDict: json.first!)
        let station3 = Station(jsonDict: json.first!)
        let station2 = Station(jsonDict: json[1])
        XCTAssert(station1 != station2)
        XCTAssert(station1 == station3)

    }
    

    
}
