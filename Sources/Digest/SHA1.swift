//
//  SHA1.swift
//  SwiftRSATest
//
//  Created by Leif Ibsen on 06/02/2022.
//

class SHA1: MDImplementation {
    
    var w: Words
    
    init() {
        self.w = Words(repeating: 0, count: 80)
    }

    func doReset(_ hw: inout Words, _ hl: inout Limbs) {
        assert(hl.count == 0)
        hw[0] = 0x67452301
        hw[1] = 0xefcdab89
        hw[2] = 0x98badcfe
        hw[3] = 0x10325476
        hw[4] = 0xc3d2e1f0
    }

    func doBuffer(_ buffer: inout Bytes, _ hw: inout Words, _ hl: inout Limbs) {
        assert(hl.count == 0)
        self.w.withUnsafeMutableBufferPointer { wU in
            buffer.withUnsafeMutableBufferPointer { bufferU in
                for i in 0 ..< 16 {
                    let index = 4 * i
                    let w0 = Word(bufferU[index]) << 24
                    let w1 = Word(bufferU[index + 1]) << 16
                    let w2 = Word(bufferU[index + 2]) << 8
                    let w3 = Word(bufferU[index + 3])
                    wU[i] = w0 | w1 | w2 | w3
                }
                for i in 16 ..< 80 {
                    wU[i] = SHA1.rotateLeft(wU[i - 3] ^ wU[i - 8] ^ wU[i - 14] ^ wU[i - 16], 1)
                }
                hw.withUnsafeMutableBufferPointer { hwU in
                    var a = hwU[0]
                    var b = hwU[1]
                    var c = hwU[2]
                    var d = hwU[3]
                    var e = hwU[4]
                    var f: Word
                    var k: Word
                    for i in 0 ..< 80 {
                        if i < 20 {
                            f = (b & c) | ((~b) & d)
                            k = 0x5a827999
                        } else if i < 40 {
                            f = b ^ c ^ d
                            k = 0x6ed9eba1
                        } else if i < 60 {
                            f = (b & c) | (b & d) | (c & d)
                            k = 0x8f1bbcdc
                        } else {
                            f = b ^ c ^ d
                            k = 0xca62c1d6
                        }
                        let temp = SHA1.rotateLeft(a, 5) &+ f &+ e &+ k &+ wU[i]
                        e = d
                        d = c
                        c = SHA1.rotateLeft(b, 30)
                        b = a
                        a = temp
                    }
                    hwU[0] &+= a
                    hwU[1] &+= b
                    hwU[2] &+= c
                    hwU[3] &+= d
                    hwU[4] &+= e
                }
            }
        }
    }

    func padding(_ totalBytes: Int, _ blockSize: Int) -> Bytes {
        var l = totalBytes * 8
        let x = ((totalBytes + 8 + blockSize) / blockSize) * blockSize - totalBytes
        var b = Bytes(repeating: 0, count: x)
        b[0] = 0x80
        b[x - 1] = Byte(l & 0xff)
        l >>= 8
        b[x - 2] = Byte(l & 0xff)
        l >>= 8
        b[x - 3] = Byte(l & 0xff)
        l >>= 8
        b[x - 4] = Byte(l & 0xff)
        l >>= 8
        b[x - 5] = Byte(l & 0xff)
        l >>= 8
        b[x - 6] = Byte(l & 0xff)
        l >>= 8
        b[x - 7] = Byte(l & 0xff)
        l >>= 8
        b[x - 8] = Byte(l & 0xff)
        return b
    }
    
    static func rotateLeft(_ x: Word, _ n: Int) -> Word {
        return (x << n) | (x >> (32 - n))
    }

}
