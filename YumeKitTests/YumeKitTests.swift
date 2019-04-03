//
//  YumeKitTests.swift
//  YumeKitTests
//
//  Created by Yume on 2017/8/8.
//  Copyright © 2017年 Yume. All rights reserved.
//

import XCTest
@testable import YumeKit

class YumeKitTests: XCTestCase {
    
    var cds:[ContinuingData<Int>] = []
    
    override func setUp() {
        super.setUp()
        let a = [1,2,3,4,5]
        cds = a.compactMap {
            ContinuingData<Int>.findContinousData(array: a, middle: $0)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        if case .mn(let m, let n) = cds[0] {
            XCTAssertEqual(m, 1)
            XCTAssertEqual(n, 2)
        } else {
            assert(false)
        }
        
        if case .pmn(let p, let m, let n) = cds[2] {
            XCTAssertEqual(p, 2)
            XCTAssertEqual(m, 3)
            XCTAssertEqual(n, 4)
        } else {
            assert(false)
        }
        
        if case .pm(let p, let m) = cds[4] {
            XCTAssertEqual(p, 4)
            XCTAssertEqual(m, 5)
        } else {
            assert(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
