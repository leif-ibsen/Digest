//
//  MGF1Test.swift
//  SwiftDigestTests
//
//  Created by Leif Ibsen on 27/11/2023.
//

import XCTest
@testable import Digest

final class MGF1Test: XCTestCase {

    let foo = Bytes("foo".utf8)
    let bar = Bytes("bar".utf8)
    
    func test() throws {
        XCTAssertEqual(KDF.MGF1(.SHA1, foo, 3), Base64.hex2bytes("1ac907"))
        XCTAssertEqual(KDF.MGF1(.SHA1, foo, 5), Base64.hex2bytes("1ac9075cd4"))
        XCTAssertEqual(KDF.MGF1(.SHA1, bar, 5), Base64.hex2bytes("bc0c655e01"))
        XCTAssertEqual(KDF.MGF1(.SHA1, bar, 50), Base64.hex2bytes(
            "bc0c655e016bc2931d85a2e675181adcef7f581f76df2739da74faac41627be2f7f415c89e983fd0ce80ced9878641cb4876"))
        XCTAssertEqual(KDF.MGF1(.SHA2_256, bar, 5), Base64.hex2bytes(
            "382576a784"))
        XCTAssertEqual(KDF.MGF1(.SHA2_256, bar, 50), Base64.hex2bytes(
            "382576a7841021cc28fc4c0948753fb8312090cea942ea4c4e735d10dc724b155f9f6069f289d61daca0cb814502ef04eae1"))        
    }

}
