//
//  Util.swift
//  
//
//  Created by Leif Ibsen on 20/10/2023.
//

import XCTest
@testable import Digest

final class Util: XCTestCase {
    
    // Test vectors from http://www.di-mgt.com.au/sha_testvectors.html

    static let s1 = Bytes("".utf8)
    static let s2 = Bytes("abc".utf8)
    static let s3 = Bytes("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".utf8)
    static let s4 = Bytes(
        "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".utf8)
    static let s5 = Bytes(repeating: 0x61, count: 1000000)

}
