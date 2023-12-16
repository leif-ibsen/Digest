//
//  HMACTest.swift
//  SwiftDigestTests
//
//  Created by Leif Ibsen on 26/03/2022.
//

import XCTest
@testable import Digest

class HMACTest: XCTestCase {

    // Test vectors from RFC 2202 and RFC 4231

    struct testStruct {
        let key: Bytes
        let data: Bytes
        let mac1: Bytes
        let mac2_224: Bytes
        let mac2_256: Bytes
        let mac2_384: Bytes
        let mac2_512: Bytes
        let mac3_224: Bytes
        let mac3_256: Bytes
        let mac3_384: Bytes
        let mac3_512: Bytes

        init(key: Bytes, data: Bytes, mac1: Bytes,
             mac2_224: Bytes, mac2_256: Bytes, mac2_384: Bytes, mac2_512: Bytes,
             mac3_224: Bytes, mac3_256: Bytes, mac3_384: Bytes, mac3_512: Bytes) {
            self.key = key
            self.data = data
            self.mac1 = mac1
            self.mac2_224 = mac2_224
            self.mac2_256 = mac2_256
            self.mac2_384 = mac2_384
            self.mac2_512 = mac2_512
            self.mac3_224 = mac3_224
            self.mac3_256 = mac3_256
            self.mac3_384 = mac3_384
            self.mac3_512 = mac3_512
        }
    }

    static let key1 = Util.hex2bytes("0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
    static let data1 = Util.hex2bytes("4869205468657265")
    static let key2 = Util.hex2bytes("4a656665")
    static let data2 = Util.hex2bytes("7768617420646f2079612077616e7420666f72206e6f7468696e673f")
    static let key3 = Util.hex2bytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    static let data3 = Util.hex2bytes("dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd")
    static let key4 = Util.hex2bytes("0102030405060708090a0b0c0d0e0f10111213141516171819")
    static let data4 = Util.hex2bytes("cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd")
    static let key6 = Util.hex2bytes(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    static let data6 = Util.hex2bytes(
        "54657374205573696e67204c6172676572205468616e20426c6f636b2d53697a65204b6579202d2048617368204b6579204669727374")
    static let key7 = Util.hex2bytes(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    static let data7 = Util.hex2bytes(
        "5468697320697320612074657374207573696e672061206c6172676572207468616e20626c6f636b2d73697a65206b657920616e642061206c6172676572207468616e20626c6f636b2d73697a6520646174612e20546865206b6579206e6565647320746f20626520686173686564206265666f7265206265696e6720757365642062792074686520484d414320616c676f726974686d2e")

    let tests: [testStruct] = [
        testStruct(
            key: key1,
            data: data1,
            mac1: Util.hex2bytes(
                "b617318655057264e28bc0b6fb378c8ef146be00"),
            mac2_224: Util.hex2bytes(
                "896fb1128abbdf196832107cd49df33f47b4b1169912ba4f53684b22"),
            mac2_256: Util.hex2bytes(
                "b0344c61d8db38535ca8afceaf0bf12b881dc200c9833da726e9376c2e32cff7"),
            mac2_384: Util.hex2bytes(
                "afd03944d84895626b0825f4ab46907f15f9dadbe4101ec682aa034c7cebc59cfaea9ea9076ede7f4af152e8b2fa9cb6"),
            mac2_512: Util.hex2bytes(
                "87aa7cdea5ef619d4ff0b4241a1d6cb02379f4e2ce4ec2787ad0b30545e17cdedaa833b7d6b8a702038b274eaea3f4e4be9d914eeb61f1702e696c203a126854"),
            mac3_224: Util.hex2bytes(
                "3b16546bbc7be2706a031dcafd56373d9884367641d8c59af3c860f7"),
            mac3_256: Util.hex2bytes(
                "ba85192310dffa96e2a3a40e69774351140bb7185e1202cdcc917589f95e16bb"),
            mac3_384: Util.hex2bytes(
                "68d2dcf7fd4ddd0a2240c8a437305f61fb7334cfb5d0226e1bc27dc10a2e723a20d370b47743130e26ac7e3d532886bd"),
            mac3_512: Util.hex2bytes(
                "eb3fbd4b2eaab8f5c504bd3a41465aacec15770a7cabac531e482f860b5ec7ba47ccb2c6f2afce8f88d22b6dc61380f23a668fd3888bb80537c0a0b86407689e")
        ),
        testStruct(
            key: key2,
            data: data2,
            mac1: Util.hex2bytes(
                "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79"),
            mac2_224: Util.hex2bytes(
                "a30e01098bc6dbbf45690f3a7e9e6d0f8bbea2a39e6148008fd05e44"),
            mac2_256: Util.hex2bytes(
                "5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843"),
            mac2_384: Util.hex2bytes(
                "af45d2e376484031617f78d2b58a6b1b9c7ef464f5a01b47e42ec3736322445e8e2240ca5e69e2c78b3239ecfab21649"),
            mac2_512: Util.hex2bytes(
                "164b7a7bfcf819e2e395fbe73b56e0a387bd64222e831fd610270cd7ea2505549758bf75c05a994a6d034f65f8f0e6fdcaeab1a34d4a6b4b636e070a38bce737"),
            mac3_224: Util.hex2bytes(
                "7fdb8dd88bd2f60d1b798634ad386811c2cfc85bfaf5d52bbace5e66"),
            mac3_256: Util.hex2bytes(
                "c7d4072e788877ae3596bbb0da73b887c9171f93095b294ae857fbe2645e1ba5"),
            mac3_384: Util.hex2bytes(
                "f1101f8cbf9766fd6764d2ed61903f21ca9b18f57cf3e1a23ca13508a93243ce48c045dc007f26a21b3f5e0e9df4c20a"),
            mac3_512: Util.hex2bytes(
                "5a4bfeab6166427c7a3647b747292b8384537cdb89afb3bf5665e4c5e709350b287baec921fd7ca0ee7a0c31d022a95e1fc92ba9d77df883960275beb4e62024")
        ),
        testStruct(
            key: key3,
            data: data3,
            mac1: Util.hex2bytes(
                "125d7342b9ac11cd91a39af48aa17b4f63f175d3"),
            mac2_224: Util.hex2bytes(
                "7fb3cb3588c6c1f6ffa9694d7d6ad2649365b0c1f65d69d1ec8333ea"),
            mac2_256: Util.hex2bytes(
                "773ea91e36800e46854db8ebd09181a72959098b3ef8c122d9635514ced565fe"),
            mac2_384: Util.hex2bytes(
                "88062608d3e6ad8a0aa2ace014c8a86f0aa635d947ac9febe83ef4e55966144b2a5ab39dc13814b94e3ab6e101a34f27"),
            mac2_512: Util.hex2bytes(
                "fa73b0089d56a284efb0f0756c890be9b1b5dbdd8ee81a3655f83e33b2279d39bf3e848279a722c806b485a47e67c807b946a337bee8942674278859e13292fb"),
            mac3_224: Util.hex2bytes(
                "676cfc7d16153638780390692be142d2df7ce924b909c0c08dbfdc1a"),
            mac3_256: Util.hex2bytes(
                "84ec79124a27107865cedd8bd82da9965e5ed8c37b0ac98005a7f39ed58a4207"),
            mac3_384: Util.hex2bytes(
                "275cd0e661bb8b151c64d288f1f782fb91a8abd56858d72babb2d476f0458373b41b6ab5bf174bec422e53fc3135ac6e"),
            mac3_512: Util.hex2bytes(
                "309e99f9ec075ec6c6d475eda1180687fcf1531195802a99b5677449a8625182851cb332afb6a89c411325fbcbcd42afcb7b6e5aab7ea42c660f97fd8584bf03")
        ),
        testStruct(
            key: key4,
            data: data4,
            mac1: Util.hex2bytes(
                "4c9007f4026250c6bc8414f9bf50c86c2d7235da"),
            mac2_224: Util.hex2bytes(
                "6c11506874013cac6a2abc1bb382627cec6a90d86efc012de7afec5a"),
            mac2_256: Util.hex2bytes(
                "82558a389a443c0ea4cc819899f2083a85f0faa3e578f8077a2e3ff46729665b"),
            mac2_384: Util.hex2bytes(
                "3e8a69b7783c25851933ab6290af6ca77a9981480850009cc5577c6e1f573b4e6801dd23c4a7d679ccf8a386c674cffb"),
            mac2_512: Util.hex2bytes(
                "b0ba465637458c6990e5a8c5f61d4af7e576d97ff94b872de76f8050361ee3dba91ca5c11aa25eb4d679275cc5788063a5f19741120c4f2de2adebeb10a298dd"),
            mac3_224: Util.hex2bytes(
                "a9d7685a19c4e0dbd9df2556cc8a7d2a7733b67625ce594c78270eeb"),
            mac3_256: Util.hex2bytes(
                "57366a45e2305321a4bc5aa5fe2ef8a921f6af8273d7fe7be6cfedb3f0aea6d7"),
            mac3_384: Util.hex2bytes(
                "3a5d7a879702c086bc96d1dd8aa15d9c46446b95521311c606fdc4e308f4b984da2d0f9449b3ba8425ec7fb8c31bc136"),
            mac3_512: Util.hex2bytes(
                "b27eab1d6e8d87461c29f7f5739dd58e98aa35f8e823ad38c5492a2088fa0281993bbfff9a0e9c6bf121ae9ec9bb09d84a5ebac817182ea974673fb133ca0d1d")
        ),
        testStruct(
            key: key6,
            data: data6,
            mac1: Util.hex2bytes(
                "90d0dace1c1bdc957339307803160335bde6df2b"),
            mac2_224: Util.hex2bytes(
                "95e9a0db962095adaebe9b2d6f0dbce2d499f112f2d2b7273fa6870e"),
            mac2_256: Util.hex2bytes(
                "60e431591ee0b67f0d8a26aacbf5b77f8e0bc6213728c5140546040f0ee37f54"),
            mac2_384: Util.hex2bytes(
                "4ece084485813e9088d2c63a041bc5b44f9ef1012a2b588f3cd11f05033ac4c60c2ef6ab4030fe8296248df163f44952"),
            mac2_512: Util.hex2bytes(
                "80b24263c7c1a3ebb71493c1dd7be8b49b46d1f41b4aeec1121b013783f8f3526b56d037e05f2598bd0fd2215d6a1e5295e64f73f63f0aec8b915a985d786598"),
            mac3_224: Util.hex2bytes(
                "b4a1f04c00287a9b7f6075b313d279b833bc8f75124352d05fb9995f"),
            mac3_256: Util.hex2bytes(
                "ed73a374b96c005235f948032f09674a58c0ce555cfc1f223b02356560312c3b"),
            mac3_384: Util.hex2bytes(
                "0fc19513bf6bd878037016706a0e57bc528139836b9a42c3d419e498e0e1fb9616fd669138d33a1105e07c72b6953bcc"),
            mac3_512: Util.hex2bytes(
                "00f751a9e50695b090ed6911a4b65524951cdc15a73a5d58bb55215ea2cd839ac79d2b44a39bafab27e83fde9e11f6340b11d991b1b91bf2eee7fc872426c3a4")
        ),
        testStruct(
            key: key7,
            data: data7,
            mac1: Util.hex2bytes(
                "217e44bb08b6e06a2d6c30f3cb9f537f97c63356"),
            mac2_224: Util.hex2bytes(
                "3a854166ac5d9f023f54d517d0b39dbd946770db9c2b95c9f6f565d1"),
            mac2_256: Util.hex2bytes(
                "9b09ffa71b942fcb27635fbcd5b0e944bfdc63644f0713938a7f51535c3a35e2"),
            mac2_384: Util.hex2bytes(
                "6617178e941f020d351e2f254e8fd32c602420feb0b8fb9adccebb82461e99c5a678cc31e799176d3860e6110c46523e"),
            mac2_512: Util.hex2bytes(
                "e37b6a775dc87dbaa4dfa9f96e5e3ffddebd71f8867289865df5a32d20cdc944b6022cac3c4982b10d5eeb55c3e4de15134676fb6de0446065c97440fa8c6a58"),
            mac3_224: Util.hex2bytes(
                "05d8cd6d00faea8d1eb68ade28730bbd3cbab6929f0a086b29cd62a0"),
            mac3_256: Util.hex2bytes(
                "65c5b06d4c3de32a7aef8763261e49adb6e2293ec8e7c61e8de61701fc63e123"),
            mac3_384: Util.hex2bytes(
                "026fdf6b50741e373899c9f7d5406d4eb09fc6665636fc1a530029ddf5cf3ca5a900edce01f5f61e2f408cdf2fd3e7e8"),
            mac3_512: Util.hex2bytes(
                "38a456a004bd10d32c9ab8336684112862c3db61adcca31829355eaf46fd5c73d06a1f0d13fec9a652fb3811b577b1b1d1b9789f97ae5b83c6f44dfcf1d67eba")
        ),
    ]

    func test() {
        for t in tests {
            let hmac1 = HMAC(.SHA1, t.key)
            XCTAssertEqual(t.mac1, hmac1.compute(t.data))
            
            let hmac2_224 = HMAC(.SHA2_224, t.key)
            XCTAssertEqual(t.mac2_224, hmac2_224.compute(t.data))
            let hmac2_256 = HMAC(.SHA2_256, t.key)
            XCTAssertEqual(t.mac2_256, hmac2_256.compute(t.data))
            let hmac2_384 = HMAC(.SHA2_384, t.key)
            XCTAssertEqual(t.mac2_384, hmac2_384.compute(t.data))
            let hmac2_512 = HMAC(.SHA2_512, t.key)
            XCTAssertEqual(t.mac2_512, hmac2_512.compute(t.data))
            
            let hmac3_224 = HMAC(.SHA3_224, t.key)
            XCTAssertEqual(t.mac3_224, hmac3_224.compute(t.data))
            let hmac3_256 = HMAC(.SHA3_256, t.key)
            XCTAssertEqual(t.mac3_256, hmac3_256.compute(t.data))
            let hmac3_384 = HMAC(.SHA3_384, t.key)
            XCTAssertEqual(t.mac3_384, hmac3_384.compute(t.data))
            let hmac3_512 = HMAC(.SHA3_512, t.key)
            XCTAssertEqual(t.mac3_512, hmac3_512.compute(t.data))
        }
    }

}
