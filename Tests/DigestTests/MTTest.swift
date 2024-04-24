//
//  MTTest.swift
//  
//
//  Created by Leif Ibsen on 23/04/2024.
//

import XCTest
@testable import Digest

final class MTTest: XCTestCase {

    func doTestInt(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [Int](repeating: 0, count: 1000)
        var x2 = [Int](repeating: 0, count: 1000)
        var state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int.min ... Int.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int.min ... Int.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: 0 ... Int.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: 0 ... Int.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int.min ... 0)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestInt32(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [Int32](repeating: 0, count: 1000)
        var x2 = [Int32](repeating: 0, count: 1000)
        var state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int32.min ... Int32.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int32.min ... Int32.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: 0 ... Int32.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: 0 ... Int32.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int32.min ... 0)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int32.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestInt64(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [Int64](repeating: 0, count: 1000)
        var x2 = [Int64](repeating: 0, count: 1000)
        var state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int64.min ... Int64.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int64.min ... Int64.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: 0 ... Int64.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: 0 ... Int64.max)
        }
        XCTAssertEqual(x1, x2)
        state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomInt(in: Int64.min ... 0)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomInt(in: Int64.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [UInt](repeating: 0, count: 1000)
        var x2 = [UInt](repeating: 0, count: 1000)
        let state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomUInt(in: 0 ... UInt.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomUInt(in: 0 ... UInt.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt32(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [UInt32](repeating: 0, count: 1000)
        var x2 = [UInt32](repeating: 0, count: 1000)
        let state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomUInt(in: 0 ... UInt32.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomUInt(in: 0 ... UInt32.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt64(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        var x1 = [UInt64](repeating: 0, count: 1000)
        var x2 = [UInt64](repeating: 0, count: 1000)
        let state = mt.getState()
        for i in 0 ..< x1.count {
            x1[i] = mt.randomUInt(in: 0 ... UInt64.max)
        }
        mt.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = mt.randomUInt(in: 0 ... UInt64.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestMinMaxInt(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        XCTAssertTrue(mt.randomInt(in: 0 ... 0) == 0)
        XCTAssertTrue(mt.randomInt(in: 0 ..< 1) == 0)
        XCTAssertTrue(mt.randomInt(in: Int.max ... Int.max) == Int.max)
        XCTAssertTrue(mt.randomInt(in: Int.max - 1 ..< Int.max) == Int.max - 1)
        let x = mt.randomInt(in: Int.max - 1 ... Int.max)
        XCTAssertTrue(x == Int.max - 1 || x == Int.max)
        XCTAssertTrue(mt.randomInt(in: Int.min ... Int.min) == Int.min)
        XCTAssertTrue(mt.randomInt(in: Int.min ..< Int.min + 1) == Int.min)
        let x_1 = mt.randomInt(in: Int.min ... Int.min + 1)
        XCTAssertTrue(x_1 == Int.min || x_1 == Int.min + 1)

        XCTAssertTrue(mt.randomInt(in: Int32(0) ... Int32(0)) == 0)
        XCTAssertTrue(mt.randomInt(in: Int32(0) ..< Int32(1)) == 0)
        XCTAssertTrue(mt.randomInt(in: Int32.max ... Int32.max) == Int32.max)
        XCTAssertTrue(mt.randomInt(in: Int32.max - 1 ..< Int32.max) == Int32.max - 1)
        let x32 = mt.randomInt(in: Int32.max - 1 ... Int32.max)
        XCTAssertTrue(x32 == Int32.max - 1 || x32 == Int32.max)
        XCTAssertTrue(mt.randomInt(in: Int32.min ... Int32.min) == Int32.min)
        XCTAssertTrue(mt.randomInt(in: Int32.min ..< Int32.min + 1) == Int32.min)
        let x32_1 = mt.randomInt(in: Int32.min ... Int32.min + 1)
        XCTAssertTrue(x32_1 == Int32.min || x32_1 == Int32.min + 1)

        XCTAssertTrue(mt.randomInt(in: Int64(0) ... Int64(0)) == 0)
        XCTAssertTrue(mt.randomInt(in: Int64(0) ..< Int64(1)) == 0)
        XCTAssertTrue(mt.randomInt(in: Int64.max ... Int64.max) == Int64.max)
        XCTAssertTrue(mt.randomInt(in: Int64.max - 1 ..< Int64.max) == Int64.max - 1)
        let x64 = mt.randomInt(in: Int64.max - 1 ... Int64.max)
        XCTAssertTrue(x64 == Int64.max - 1 || x64 == Int64.max)
        XCTAssertTrue(mt.randomInt(in: Int64.min ... Int64.min) == Int64.min)
        XCTAssertTrue(mt.randomInt(in: Int64.min ..< Int64.min + 1) == Int64.min)
        let x64_1 = mt.randomInt(in: Int64.min ... Int64.min + 1)
        XCTAssertTrue(x64_1 == Int64.min || x64_1 == Int64.min + 1)
    }

    func doTestMinMaxUInt(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        XCTAssertTrue(mt.randomUInt(in: UInt(0) ... UInt(0)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt(0) ..< UInt(1)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt.max ... UInt.max) == UInt.max)
        XCTAssertTrue(mt.randomUInt(in: UInt.max - 1 ..< UInt.max) == UInt.max - 1)
        let x = mt.randomUInt(in: UInt.max - 1 ... UInt.max)
        XCTAssertTrue(x == UInt.max - 1 || x == UInt.max)
        XCTAssertTrue(mt.randomUInt(in: UInt.min ... UInt.min) == UInt.min)
        XCTAssertTrue(mt.randomUInt(in: UInt.min ..< UInt.min + 1) == UInt.min)

        XCTAssertTrue(mt.randomUInt(in: UInt32(0) ... UInt32(0)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt32(0) ..< UInt32(1)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt32.max ... UInt32.max) == UInt32.max)
        XCTAssertTrue(mt.randomUInt(in: UInt32.max - 1 ..< UInt32.max) == UInt32.max - 1)
        let x32 = mt.randomUInt(in: UInt32.max - 1 ... UInt32.max)
        XCTAssertTrue(x32 == UInt32.max - 1 || x32 == UInt32.max)
        XCTAssertTrue(mt.randomUInt(in: UInt32.min ... UInt32.min) == UInt32.min)
        XCTAssertTrue(mt.randomUInt(in: UInt32.min ..< UInt32.min + 1) == UInt32.min)

        XCTAssertTrue(mt.randomUInt(in: UInt64(0) ... UInt64(0)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt64(0) ..< UInt64(1)) == 0)
        XCTAssertTrue(mt.randomUInt(in: UInt64.max ... UInt64.max) == UInt64.max)
        XCTAssertTrue(mt.randomUInt(in: UInt64.max - 1 ..< UInt64.max) == UInt64.max - 1)
        let x64 = mt.randomUInt(in: UInt64.max - 1 ... UInt64.max)
        XCTAssertTrue(x64 == UInt64.max - 1 || x64 == UInt64.max)
        XCTAssertTrue(mt.randomUInt(in: UInt64.min ... UInt64.min) == UInt64.min)
        XCTAssertTrue(mt.randomUInt(in: UInt64.min ..< UInt64.min + 1) == UInt64.min)
    }

    func doTestFloat(_ kind: MT.Kind) throws {
        let mt = MT(kind: kind)
        for _ in 0 ..< 1000 {
            let x = mt.randomFloat(in: 0.0 ..< 1.0)
            XCTAssertTrue(0.0 <= x && x < 1.0)
        }
        for _ in 0 ..< 1000 {
            let x = mt.randomFloat(in: 0.0 ... 1.0)
            XCTAssertTrue(0.0 <= x && x <= 1.0)
        }
    }

    func testInt() throws {
        try doTestInt(.MT32)
        try doTestInt(.MT64)
        try doTestInt32(.MT32)
        try doTestInt32(.MT64)
        try doTestInt64(.MT32)
        try doTestInt64(.MT64)
    }

    func testUInt() throws {
        try doTestUInt(.MT32)
        try doTestUInt(.MT64)
        try doTestUInt32(.MT32)
        try doTestUInt32(.MT64)
        try doTestUInt64(.MT32)
        try doTestUInt64(.MT64)
    }

    func testMinMaxInt() throws {
        try doTestMinMaxInt(.MT32)
        try doTestMinMaxInt(.MT64)
    }

    func testMinMaxUInt() throws {
        try doTestMinMaxUInt(.MT32)
        try doTestMinMaxUInt(.MT64)
    }

    func testFloat() throws {
        try doTestFloat(.MT32)
        try doTestFloat(.MT64)
    }

}
