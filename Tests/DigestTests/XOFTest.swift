//
//  XOFTest.swift
//  
//
//  Created by Leif Ibsen on 28/11/2023.
//

import XCTest
@testable import Digest

final class XOFTest: XCTestCase {

    // NIST test vectors

    struct testStruct {
        let seed: Bytes
        let output: Bytes

        init(seed: String, output: String) {
            self.seed = Util.hex2bytes(seed)
            self.output = Util.hex2bytes(output)
        }
    }
    
    let tests128: [testStruct] = [
        testStruct(
            seed: "",
            output: "7f9c2ba4e88f827d616045507605853e"
        ),
        testStruct(
            seed: "0e",
            output: "fa996dafaa208d72287c23bc4ed4bfd5"
        ),
        testStruct(
            seed: "d9e8",
            output: "c7211512340734235bb8d3c4651495aa"
        ),
        testStruct(
            seed: "29d97029326800f97f8db0d37078f91c6e3cb21e2033e099e29ecf7a738d62eaedffa78afb49aefd46bc9ca83082fbb5c5",
            output: "e087f5cc78aef2d5e3ec450d2270458b"
        ),
    ]

    let tests256: [testStruct] = [
        testStruct(
            seed: "",
            output: "46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762f"
        ),
        testStruct(
            seed: "0f",
            output: "aabb07488ff9edd05d6a603b7791b60a16d45093608f1badc0c9cc9a9154f215"
        ),
        testStruct(
            seed: "0dc1",
            output: "8e2df9d379bb034aee064e965f960ebb418a9bb535025fb96427f678cf207877"
        ),
        testStruct(
            seed: "999cd1673395cb04fc9bd7cd1eff8b4c0b3c0b6c113734de2ec51abc256eb56cd171d7c8ba07617be6ecb7aef21c71e561",
            output: "204b00fa02d648c19e3ab0638c24f3c4e9ba194e769d6d7efd64ec363fef5a72"
        ),
    ]

    func test128() throws {
        for t in tests128 {
            var x = Bytes(repeating: 0, count: t.output.count)
            let xof1 = XOF(.XOF128, t.seed)
            xof1.read(&x)
            XCTAssertEqual(x, t.output)
            var x1 = Bytes(repeating: 0, count: x.count / 2)
            var x2 = Bytes(repeating: 0, count: x.count - x1.count)
            let xof2 = XOF(.XOF128, t.seed)
            xof2.read(&x1)
            xof2.read(&x2)
            XCTAssertEqual(x, x1 + x2)
        }
    }

    func test256() throws {
        for t in tests256 {
            var x = Bytes(repeating: 0, count: t.output.count)
            let xof1 = XOF(.XOF256, t.seed)
            xof1.read(&x)
            XCTAssertEqual(x, t.output)
            var x1 = Bytes(repeating: 0, count: x.count / 2)
            var x2 = Bytes(repeating: 0, count: x.count - x1.count)
            let xof2 = XOF(.XOF256, t.seed)
            xof2.read(&x1)
            xof2.read(&x2)
            XCTAssertEqual(x, x1 + x2)
        }
    }

    func test1() {
        let seed: Bytes = [1, 2, 3]
        var x1 = Bytes(repeating: 0, count: 500)
        var x2 = Bytes(repeating: 0, count: 1)
        var x3 = Bytes(repeating: 0, count: 500)
        var x = Bytes(repeating: 0, count: x1.count + x2.count + x3.count)
        let xof123 = XOF(.XOF128, seed)
        xof123.read(&x1)
        xof123.read(&x2)
        xof123.read(&x3)
        let xof = XOF(.XOF128, seed)
        xof.read(&x)
        XCTAssertEqual(x, x1 + x2 + x3)
        let xof1 = XOF(.XOF128, seed)
        XCTAssertEqual(x, xof1.read(x.count))
    }

    func test2() {
        let seed: Bytes = [1, 2, 3]
        var x1 = Bytes(repeating: 0, count: 500)
        var x2 = Bytes(repeating: 0, count: 1)
        var x3 = Bytes(repeating: 0, count: 500)
        var x = Bytes(repeating: 0, count: x1.count + x2.count + x3.count)
        let xof123 = XOF(.XOF256, seed)
        xof123.read(&x1)
        xof123.read(&x2)
        xof123.read(&x3)
        let xof = XOF(.XOF256, seed)
        xof.read(&x)
        XCTAssertEqual(x, x1 + x2 + x3)
        let xof1 = XOF(.XOF256, seed)
        XCTAssertEqual(x, xof1.read(x.count))
    }
}
