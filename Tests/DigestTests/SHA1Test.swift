//
//  SHA1Test.swift
//  SwiftDigestTests
//
//  Created by Leif Ibsen on 27/11/2023.
//

import XCTest
@testable import Digest

final class SHA1Test: XCTestCase {

    // Test vectors from http://www.di-mgt.com.au/sha_testvectors.html

    func test1() {
        let md = MessageDigest(.SHA1)
        md.update(Util.s1)
        XCTAssertEqual(Base64.bytes2hex(md.digest()), "da39a3ee5e6b4b0d3255bfef95601890afd80709")
        md.update(Util.s2)
        XCTAssertEqual(Base64.bytes2hex(md.digest()), "a9993e364706816aba3e25717850c26c9cd0d89d")
        md.update(Util.s3)
        XCTAssertEqual(Base64.bytes2hex(md.digest()), "84983e441c3bd26ebaae4aa1f95129e5e54670f1")
        md.update(Util.s4)
        XCTAssertEqual(Base64.bytes2hex(md.digest()), "a49b2446a02c645bf419f995b67091253a04a259")
        md.update(Util.s5)
        XCTAssertEqual(Base64.bytes2hex(md.digest()), "34aa973cd4c4daa4f61eeb2bdbad27316534016f")
    }

}
