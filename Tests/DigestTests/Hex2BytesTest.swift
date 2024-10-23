//
//  Hex2BytesTest.swift
//  Digest
//
//  Created by Leif Ibsen on 02/10/2024.
//

import XCTest
@testable import Digest

final class Hex2BytesTest: XCTestCase {
 
    func test1() throws {
        XCTAssertNil(Base64.hex2bytes("1"))
        XCTAssertEqual(Base64.hex2bytes(""), [])
        XCTAssertEqual(Base64.hex2bytes("0123456789abcdef"), Base64.hex2bytes("0123456789ABCDEF"))
    }
    
    func test2() throws {
        var x = Bytes(repeating: 0, count: 100)
        guard SecRandomCopyBytes(kSecRandomDefault, x.count, &x) == errSecSuccess else {
            fatalError("random failed")
        }
        XCTAssertEqual(Base64.bytes2hex(x, false), Base64.bytes2hex(x, true).uppercased())
        XCTAssertEqual(Base64.bytes2hex(x, true), Base64.bytes2hex(x, false).lowercased())
        XCTAssertEqual(x, Base64.hex2bytes(Base64.bytes2hex(x, false)))
        XCTAssertEqual(x, Base64.hex2bytes(Base64.bytes2hex(x, true)))
    }
}
