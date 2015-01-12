//
//  DiffableArrayTests.swift
//  DiffableArrayTests
//
//  Created by Safx Developer on 2015/01/09.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import UIKit
import XCTest

class DiffableArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArrayDiffer_init() {
        let a = ArrayDiffer(oldValue: ["a", "b", "c", "d"], newValue: ["a", "b", "c"])
        XCTAssertEqual(a.oldValue, ["a", "b", "c", "d"])
        XCTAssertEqual(a.newValue, ["a", "b", "c"])
    }
    
    func testArrayDiffer_same1() {
        let a = ArrayDiffer(oldValue: [Int](), newValue: [Int]())
        let d = a.diff()
        XCTAssertEqual(d.added, [])
        XCTAssertEqual(d.removed, [])
        XCTAssertEqual(d.modified, [])
    }
    
    func testArrayDiffer_same2() {
        let a = ArrayDiffer(oldValue: ["a", "b", "c"], newValue: ["a", "b", "c"])
        let d = a.diff()
        XCTAssertEqual(d.added, [])
        XCTAssertEqual(d.removed, [])
        XCTAssertEqual(d.modified, [])
    }
    
    func testArrayDiffer_differ1() {
        let a = ArrayDiffer(oldValue: ["a", "b", "c", "d"], newValue: ["a", "b", "c"])
        let d = a.diff()
        XCTAssertEqual(d.added, [])
        XCTAssertEqual(d.removed, [3])
        XCTAssertEqual(d.modified, [])
    }
    
    func testArrayDiffer_differ2() {
        let a = ArrayDiffer(oldValue: ["a", "b", "c", "d"], newValue: [])
        let d = a.diff()
        XCTAssertEqual(d.added, [])
        XCTAssertEqual(d.removed, [0,1,2,3])
        XCTAssertEqual(d.modified, [])
    }
    
    func testArrayDiffer_differ3() {
        let a = ArrayDiffer(oldValue: [], newValue: ["a", "b", "c", "d"])
        let d = a.diff()
        XCTAssertEqual(d.added, [0,1,2,3])
        XCTAssertEqual(d.removed, [])
        XCTAssertEqual(d.modified, [])
    }

    func testArrayDiffer_differ4() {
        let a = ArrayDiffer(oldValue: ["b", "c", "e", "f"], newValue: ["a", "b", "c", "d"])
        let d = a.diff()
        XCTAssertEqual(d.added, [0,3])
        XCTAssertEqual(d.removed, [2,3])
        XCTAssertEqual(d.modified, [])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
