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

    // Convert a hex string to the corresponding byte array.
    static func hex2bytes(_ hex: String) -> Bytes {
        var b: Bytes = []
        var odd = false
        var x = Byte(0)
        var y = Byte(0)
        for c in hex {
            switch c {
            case "0" ... "9":
                x = c.asciiValue! - 48
            case "a" ... "f":
                x = c.asciiValue! - 87
            case "A" ... "F":
                x = c.asciiValue! - 55
            default:
                fatalError("hex2bytes")
            }
            if odd {
                b.append(y * 16 + x)
            } else {
                y = x
            }
            odd = !odd
        }
        if odd {
            fatalError("hex2bytes")
        }
        return b
    }

    static func bytes2hex(_ x: Bytes) -> String {
        let hexDigits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        var s = ""
        for b in x {
            s.append(hexDigits[Int(b >> 4)])
            s.append(hexDigits[Int(b & 0xf)])
        }
        return s
    }
    
}
