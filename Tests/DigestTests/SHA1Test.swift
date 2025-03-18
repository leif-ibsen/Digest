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
    
    // NIST CAVP test vectors
    
    struct testStruct {
        let seed: Bytes
        let output: Bytes
        
        init(seed: String, output: String) {
            self.seed = Base64.hex2bytes(seed)!
            self.output = Base64.hex2bytes(output)!
        }
    }
    
    let testsSHA1: [testStruct] = [
        testStruct(
            seed: "",
            output: "da39a3ee5e6b4b0d3255bfef95601890afd80709"
        ),
        testStruct(
            seed: "36",
            output: "c1dfd96eea8cc2b62785275bca38ac261256e278"
        ),
        testStruct(
            seed: "195a",
            output: "0a1c2d555bbe431ad6288af5a54f93e0449c9232"
        ),
        testStruct(
            seed: "df4bd2",
            output: "bf36ed5d74727dfd5d7854ec6b1d49468d8ee8aa"
        ),
        testStruct(
            seed: "9e61e55d9ed37b1c20",
            output: "411ccee1f6e3677df12698411eb09d3ff580af97"
        ),
        testStruct(
            seed: "6fda97527a662552be15efaeba32a3aea4ed449abb5c1ed8d9bfff544708a425d69b72",
            output: "01b4646180f1f6d2e06bbe22c20e50030322673a"
        ),
        testStruct(
            seed: "45927e32ddf801caf35e18e7b5078b7f5435278212ec6bb99df884f49b327c6486feae46ba187dc1cc9145121e1492e6b06e9007394dc33b7748f86ac3207cfe",
            output: "a70cfbfe7563dd0e665c7c6715a96a8d756950c0"
        ),
        testStruct(
            seed: "7c9c67323a1df1adbfe5ceb415eaef0155ece2820f4d50c1ec22cba4928ac656c83fe585db6a78ce40bc42757aba7e5a3f582428d6ca68d0c3978336a6efb729613e8d9979016204bfd921322fdd5222183554447de5e6e9bbe6edf76d7b71e18dc2e8d6dc89b7398364f652fafc734329aafa3dcd45d4f31e388e4fafd7fc6495f37ca5cbab7f54d586463da4bfeaa3bae09f7b8e9239d832b4f0a733aa609cc1f8d4",
            output: "d8fd6a91ef3b6ced05b98358a99107c1fac8c807"
        ),
        testStruct(
            seed: "6cb70d19c096200f9249d2dbc04299b0085eb068257560be3a307dbd741a3378ebfa03fcca610883b07f7fea563a866571822472dade8a0bec4b98202d47a344312976a7bcb3964427eacb5b0525db22066599b81be41e5adaf157d925fac04b06eb6e01deb753babf33be16162b214e8db017212fafa512cdc8c0d0a15c10f632e8f4f47792c64d3f026004d173df50cf0aa7976066a79a8d78deeeec951dab7cc90f68d16f786671feba0b7d269d92941c4f02f432aa5ce2aab6194dcc6fd3ae36c8433274ef6b1bd0d314636be47ba38d1948343a38bf9406523a0b2a8cd78ed6266ee3c9b5c60620b308cc6b3a73c6060d5268a7d82b6a33b93a6fd6fe1de55231d12c97",
            output: "4a75a406f4de5f9e1132069d66717fc424376388"
        ),
        testStruct(
            seed: "9f07e6b7ea8b6d2bb301d6ce7019e0f27ad55abbb799e6d47681fe609af63434fb84be4309e63159b3638d0d875e7af11a28d10baa185e8902dee5b09e14621610169511a214be6f3d65a667891eded056e44b913bfee3597caeb19031c21f8da5667409fd3c9cd31aaf28c6c08495f9f7b1d135b173fbacae9b6ae79d28f201841b6213618751ef12e81b1172b526d2c5396adf569e30ea5e4b199f287063da73de6817181d672aecb88730e8dc19c587211e7770a8097b5566c69f1bbffa803b578dfd682566eb72c9750a6a1ff7380714f5e548b80ec75b9577cfbe40405ba42dd9ad9ac7d49c6ac0ec893fa647950bb8f81126f7c837388036175818bcd37509540ff52d3ba49d48f594b19a91435cb52ee4518dbe31b3ce0a5f3372f7517892070cc37c226bd307971306235eaac2b4a04413a1781e9527fc8f9574773b7371f98a4adf1259d3a5daef87683432045d541ab25b7f67a635128fc746c6fb2f4d3272d47c92d667cbc60e7c929e43ec57544f77e45a72ae9d564711116cf774cfbbada77b2a4a552164592dc82145404ba8c9aa6491a9750ad0a0bafdef99099f9b220b05621d664ebbb8e13347a0c9e056729302ad73c22287800c31d948b864dab84a42c3b762fbd314e2fb97bc4fbf68317ae735375f8d83d14dd6b16b47c68159ab59d48011cfb553764799029a8fe5eda63bb15f12f4cc79c613006c7f6f97ec75721de13b73685fe63fd6d871f9d6906025aa52a4ff6b62bf114db228042458f1b72740a78ef41e7a0dd5a79da54201f0cda778dd5567727ff720a50a303187674e79061ec9627a79d61ed8e73a31289e5c3039849fc89350ee01adec99c4601e5f9c9c68ccb95a2dc53ad11461acedb2facdfd638496ac781e793298e7e8cb601316684d3e01a5dcffb0fcefc1b93873ce072c40addaa440ae0f9cd4c3a2b0739171d495c74345cfaf08c03f0363f12a01652ee4c19c65f0c74c5369d5fcf7a0023447071086214efbcb84cbceaf001fba706b1769e2d6d090b7bf1fc4fd892f8ee8296cc1d221a00b80b25ccba74d9a22ae4ca04db6df2832d849bd38ad4c685c14e18c822f2d0f08afb1baa152c1e361a93749141f683fd437570ddb1529939540d92ff9a62de11ae1e9adf9b842419ee995d86726595e9f5d53d5523c08f760f5781dd13e095f689cc2fd7be2b9fe02f4cf16edd19acdbbd1a3de482bd2dde6b9261db000a9d11b6ba471ced70f60b4544bcb4f2a14d44f1bb1f063e86d8d4f174bf93ff2f67f5ad3f7d39b9f2ab0dc9173bf3439adbb83c4e3d34b7dc34fc2944f77251ed6b04e5e23e98943f435a431aeb945054ec98053a34ea9f1bb6b67ba9b600a8c32ae1f93907c41ca543932be63832a96e0476e50582a254d3c286710957b9843f3bff4faa6536a3c3102aec0fce38af4497d7543692f669830d0ea1ea692754bff2cf51cce38ada275d941bde0a20d2873b3bbb5402515da7ea9176d366b49ac403d4c806ef1b2030706133f77885c3944316b2e44d4d91c0efc1784aed0bd6e9d391eaff0472067cfd14bcd295c1f2fa63eab34dd045b65c81012eb7487789afd6a962fba02a0d6b58211f05ee8fd128024a351737c43bd942f2f2bf25823384a16d98a36ead959a1608f2e7ef29febb9297d0c6e05382c5a9f96cb8f0d664e6b861247cac674f77bb4ea12f143adc13b965eed3767e2bb02a97053b26ce8e6480267efe06018b92bc64d211fa3ce9dedb3707d346aea717495e54cc53f5207c9d10009df7e6ea599dedee571d9aa86b7c7db43ced5f85798ab1c3d2f4c4bbad63d061d2fe91dc6ae44c5e54dafea84811cc7c86d72b37356333eae585c7c06578ca1b43869ce21503f2ba91ceb369f33f85b927a07c4cf97747227",
            output: "37b7277fc606556160f9bc28b06fd55f4424d9cc"
        ),
    ]
    
    func test2() {
        let sha1 = MessageDigest(.SHA1)
        for t in testsSHA1 {
            sha1.update(t.seed)
            XCTAssertEqual(sha1.digest(), t.output)
        }
    }
    
}
