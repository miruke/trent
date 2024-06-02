//
//  TimeEntry_Tests.swift
//  trent Watch AppTests
//
//  Created by Ren Zhongkai on 6/2/24.
//

import XCTest
@testable import trent_Watch_App


final class TimeEntry_Tests: XCTestCase {

    var entries : [TimeEntry]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        entries = []
    }

    func testInitializers() throws {
        var cut = TimeEntry(text: "07:03 WAE")
        XCTAssertEqual(cut.hour, 7)
        XCTAssertEqual(cut.minute, 3)
        XCTAssertEqual(cut.rides, ["W", "A", "E"])
        
        cut = TimeEntry(hour: 17, minute: 33, rides: "WAE")
        XCTAssertEqual(cut.hour, 17)
        XCTAssertEqual(cut.minute, 33)
        XCTAssertEqual(cut.rides, ["W", "A", "E"])
    }
    
    func testComparison() throws {
        var t1 = TimeEntry(text: "04:22 W")
        var t2 = TimeEntry(text: "04:22 X")
        XCTAssertNotEqual(t1, t2)
        
        t1 = TimeEntry(text: "09:35 E")
        t2 = TimeEntry(text: "09:35 E")
        XCTAssertEqual(t1, t2)
    }
    
    func testHash() throws {
        var t1 = TimeEntry(text: "04:22 W")
        var t2 = TimeEntry(text: "04:22 X")
        XCTAssertNotEqual(t1.id(), t2.id())
        
        t1 = TimeEntry(text: "22:08 A")
        t2 = TimeEntry(text: "22:07 A")
        XCTAssertNotEqual(t1.id(), t2.id())
        
        t1 = TimeEntry(text: "09:35 E")
        t2 = TimeEntry(text: "09:35 E")
        XCTAssertEqual(t1.id(), t2.id())
        
        t1 = TimeEntry(text: "")
        t2 = TimeEntry(text: "09:35 E")
        XCTAssertNotEqual(t1.id(), t2.id())
    }
    
    func testRead() throws {
        FileReader.bundle = Bundle(for: type(of: self))
        let res = TimeEntry.readToArray(file: "test1")
        XCTAssertEqual(res.count, 0)
        
        let res2 = TimeEntry.readToArray(file: "test2")
        XCTAssertEqual(res2.count, 6)
    }
    
    func testFind() throws {
        entries = [
            TimeEntry(text: "04:22 W"),
            TimeEntry(text: "04:42 X"),
            TimeEntry(text: "12:30 D"),
            TimeEntry(text: "13:30 E"),
            TimeEntry(text: "14:30 F"),
            TimeEntry(text: "18:20 G"),
            TimeEntry(text: "22:36 A"),
            TimeEntry(text: "23:36 B"),
            TimeEntry(text: "23:52 C"),
            TimeEntry(text: "00:02 P"),
            TimeEntry(text: "03:08 Q"),
            TimeEntry(text: "03:32 H"),
        ]
        var res = TimeEntry.findAfter(entries: entries, hh: 11, mm: 30)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 12)
        XCTAssertEqual(res!.minute, 30)
        
        res = TimeEntry.findAfter(entries: entries, hh: 12, mm: 30)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 12)
        XCTAssertEqual(res!.minute, 30)
        
        res = TimeEntry.findAfter(entries: entries, hh: 12, mm: 32)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 13)
        XCTAssertEqual(res!.minute, 30)
        
        res = TimeEntry.findAfter(entries: entries, hh: 14, mm: 31)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 18)
        XCTAssertEqual(res!.minute, 20)
        
        res = TimeEntry.findAfter(entries: entries, hh: 23, mm: 37)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 23)
        XCTAssertEqual(res!.minute, 52)
        
        res = TimeEntry.findAfter(entries: entries, hh: 23, mm: 52)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 23)
        XCTAssertEqual(res!.minute, 52)
        
        res = TimeEntry.findAfter(entries: entries, hh: 23, mm: 58)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 0)
        XCTAssertEqual(res!.minute, 2)
        XCTAssertEqual(res!.rides, ["P"])
        
        res = TimeEntry.findAfter(entries: entries, hh: 0, mm: 3)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 3)
        XCTAssertEqual(res!.minute, 8)
        XCTAssertEqual(res!.rides, ["Q"])
        
        res = TimeEntry.findAfter(entries: entries, hh: 3, mm: 32)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 3)
        XCTAssertEqual(res!.minute, 32)
        XCTAssertEqual(res!.rides, ["H"])
        
        res = TimeEntry.findAfter(entries: entries, hh: 3, mm: 33)
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.hour, 4)
        XCTAssertEqual(res!.minute, 22)
        XCTAssertEqual(res!.rides, ["W"])
    }


}
