//
//  Base64Test.swift
//  
//
//  Created by Leif Ibsen on 06/09/2024.
//

import XCTest
@testable import Digest

final class Base64Test: XCTestCase {

    func doTest(_ s1: String, _ s2: String, _ linesize: Int) throws {
        let s = Base64.encode(Array(s1.utf8), linesize)
        XCTAssertEqual(s2, s)
        let x = Base64.decode(s)!
        XCTAssertEqual(s1, String(bytes: x, encoding: .utf8))
    }

    func test1() throws {
        try doTest("", "", 4)
        try doTest("f", "Zg==", 4)
        try doTest("fo", "Zm8=", 4)
        try doTest("foo", "Zm9v", 4)
        try doTest("foob", "Zm9v\nYg==", 4)
        try doTest("fooba", "Zm9v\nYmE=", 4)
        try doTest("foobar", "Zm9v\nYmFy", 4)
    }

    func test2() throws {
        let pem =
        """
        -----BEGIN PUBLIC KEY-----
        MEAwEAYHKoZIzj0CAQYFK4EEAAEDLAAEA6txn7CCae0d9AiGj3Rk5m9XflTCB81oe1fKZi4F4oip
        SF2u79k8TD5J
        -----END PUBLIC KEY-----
        """
        let bytes = Base64.pemDecode(pem, "PUBLIC KEY")!
        for i in 1 ... 20 {
            XCTAssertEqual(pem, Base64.pemEncode(Base64.pemDecode(Base64.pemEncode(bytes, "PUBLIC KEY", 4 * i), "PUBLIC KEY")!, "PUBLIC KEY"))
        }
    }
}
