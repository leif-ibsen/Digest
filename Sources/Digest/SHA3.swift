//
//  SHA3.swift
//  SwiftDigestTest
//
//  Created by Leif Ibsen on 24/11/2023.
//

class SHA3: MDImplementation {
    
    let RC_CONSTANTS: Limbs = [
    0x0000000000000001, 0x0000000000008082, 0x800000000000808a, 0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
    0x8000000080008081, 0x8000000000008009, 0x000000000000008a, 0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
    0x000000008000808b, 0x800000000000008b, 0x8000000000008089, 0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
    0x000000000000800a, 0x800000008000000a, 0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008 ]

    var state: Bytes
    var lanes: Limbs
    
    init() {
        self.state = Bytes(repeating: 0, count: 200)
        self.lanes = Limbs(repeating: 0, count: 25)
    }
    
    func doReset(_ hw: inout Words, _ hl: inout Limbs) {
        assert(hw.count == 0)
        assert(hl.count == 0)
        self.state = Bytes(repeating: 0, count: 200)
    }
    
    func toLanes(_ buffer: inout Bytes) {
        self.lanes.withUnsafeMutableBufferPointer { lanesU in
            buffer.withUnsafeMutableBufferPointer { bufferU in
                for y in 0 ..< 5 {
                    for x in 0 ..< 5 {
                        var b = Limb(0)
                        let nyx = 8 * (5 * y + x)
                        b |= Limb(bufferU[nyx])
                        b |= Limb(bufferU[nyx + 1]) << 8
                        b |= Limb(bufferU[nyx + 2]) << 16
                        b |= Limb(bufferU[nyx + 3]) << 24
                        b |= Limb(bufferU[nyx + 4]) << 32
                        b |= Limb(bufferU[nyx + 5]) << 40
                        b |= Limb(bufferU[nyx + 6]) << 48
                        b |= Limb(bufferU[nyx + 7]) << 56
                        lanesU[5 * y + x] = b
                    }
                }
            }
        }
    }

    func fromLanes(_ buffer: inout Bytes) {
        self.lanes.withUnsafeMutableBufferPointer { lanesU in
            buffer.withUnsafeMutableBufferPointer { bufferU in
                for y in 0 ..< 5 {
                    for x in 0 ..< 5 {
                        var b = lanesU[5 * y + x]
                        let nyx = 8 * (5 * y + x)
                        bufferU[nyx] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 1] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 2] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 3] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 4] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 5] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 6] = Byte(b & 0xff)
                        b >>= 8
                        bufferU[nyx + 7] = Byte(b & 0xff)
                        b >>= 8
                    }
                }
            }
        }
    }

    func doBuffer(_ buffer: inout Bytes, _ hw: inout Words, _ hl: inout Limbs) {
        assert(hw.count == 0)
        assert(hl.count == 0)
        toLanes(&buffer)
        for i in 0 ..< 24 {
            theta()
            phiRho()
            chi()
            
            // iota(i)
            
            self.lanes[0] ^= RC_CONSTANTS[i]
        }
        fromLanes(&buffer)
    }
    
    func theta() {
        self.lanes.withUnsafeMutableBufferPointer { lanesU in
            let c0 = lanesU[0] ^ lanesU[5] ^ lanesU[10] ^ lanesU[15] ^ lanesU[20]
            let c1 = lanesU[1] ^ lanesU[6] ^ lanesU[11] ^ lanesU[16] ^ lanesU[21]
            let c2 = lanesU[2] ^ lanesU[7] ^ lanesU[12] ^ lanesU[17] ^ lanesU[22]
            let c3 = lanesU[3] ^ lanesU[8] ^ lanesU[13] ^ lanesU[18] ^ lanesU[23]
            let c4 = lanesU[4] ^ lanesU[9] ^ lanesU[14] ^ lanesU[19] ^ lanesU[24]
            let d0 = c4 ^ SHA3.rotateLeft(c1, 1)
            let d1 = c0 ^ SHA3.rotateLeft(c2, 1)
            let d2 = c1 ^ SHA3.rotateLeft(c3, 1)
            let d3 = c2 ^ SHA3.rotateLeft(c4, 1)
            let d4 = c3 ^ SHA3.rotateLeft(c0, 1)
            lanesU[0] ^= d0
            lanesU[1] ^= d1
            lanesU[2] ^= d2
            lanesU[3] ^= d3
            lanesU[4] ^= d4
            lanesU[5] ^= d0
            lanesU[6] ^= d1
            lanesU[7] ^= d2
            lanesU[8] ^= d3
            lanesU[9] ^= d4
            lanesU[10] ^= d0
            lanesU[11] ^= d1
            lanesU[12] ^= d2
            lanesU[13] ^= d3
            lanesU[14] ^= d4
            lanesU[15] ^= d0
            lanesU[16] ^= d1
            lanesU[17] ^= d2
            lanesU[18] ^= d3
            lanesU[19] ^= d4
            lanesU[20] ^= d0
            lanesU[21] ^= d1
            lanesU[22] ^= d2
            lanesU[23] ^= d3
            lanesU[24] ^= d4
        }
    }

    func phiRho() {
        self.lanes.withUnsafeMutableBufferPointer { lanesU in
            let tmp = SHA3.rotateLeft(lanesU[10], 3)
            lanesU[10] = SHA3.rotateLeft(lanesU[1], 1)
            lanesU[1] = SHA3.rotateLeft(lanesU[6], 44)
            lanesU[6] = SHA3.rotateLeft(lanesU[9], 20)
            lanesU[9] = SHA3.rotateLeft(lanesU[22], 61)
            lanesU[22] = SHA3.rotateLeft(lanesU[14], 39)
            lanesU[14] = SHA3.rotateLeft(lanesU[20], 18)
            lanesU[20] = SHA3.rotateLeft(lanesU[2], 62)
            lanesU[2] = SHA3.rotateLeft(lanesU[12], 43)
            lanesU[12] = SHA3.rotateLeft(lanesU[13], 25)
            lanesU[13] = SHA3.rotateLeft(lanesU[19], 8)
            lanesU[19] = SHA3.rotateLeft(lanesU[23], 56)
            lanesU[23] = SHA3.rotateLeft(lanesU[15], 41)
            lanesU[15] = SHA3.rotateLeft(lanesU[4], 27)
            lanesU[4] = SHA3.rotateLeft(lanesU[24], 14)
            lanesU[24] = SHA3.rotateLeft(lanesU[21], 2)
            lanesU[21] = SHA3.rotateLeft(lanesU[8], 55)
            lanesU[8] = SHA3.rotateLeft(lanesU[16], 45)
            lanesU[16] = SHA3.rotateLeft(lanesU[5], 36)
            lanesU[5] = SHA3.rotateLeft(lanesU[3], 28)
            lanesU[3] = SHA3.rotateLeft(lanesU[18], 21)
            lanesU[18] = SHA3.rotateLeft(lanesU[17], 15)
            lanesU[17] = SHA3.rotateLeft(lanesU[11], 10)
            lanesU[11] = SHA3.rotateLeft(lanesU[7], 6)
            lanesU[7] = tmp
        }
    }

    func chi() {
        self.lanes.withUnsafeMutableBufferPointer { lanesU in
            var ay0 = lanesU[0]
            var ay1 = lanesU[1]
            var ay2 = lanesU[2]
            var ay3 = lanesU[3]
            var ay4 = lanesU[4]
            lanesU[0] = ay0 ^ ((~ay1) & ay2)
            lanesU[1] = ay1 ^ ((~ay2) & ay3)
            lanesU[2] = ay2 ^ ((~ay3) & ay4)
            lanesU[3] = ay3 ^ ((~ay4) & ay0)
            lanesU[4] = ay4 ^ ((~ay0) & ay1)
            ay0 = lanesU[5]
            ay1 = lanesU[6]
            ay2 = lanesU[7]
            ay3 = lanesU[8]
            ay4 = lanesU[9]
            lanesU[5] = ay0 ^ ((~ay1) & ay2)
            lanesU[6] = ay1 ^ ((~ay2) & ay3)
            lanesU[7] = ay2 ^ ((~ay3) & ay4)
            lanesU[8] = ay3 ^ ((~ay4) & ay0)
            lanesU[9] = ay4 ^ ((~ay0) & ay1)
            ay0 = lanesU[10]
            ay1 = lanesU[11]
            ay2 = lanesU[12]
            ay3 = lanesU[13]
            ay4 = lanesU[14]
            lanesU[10] = ay0 ^ ((~ay1) & ay2)
            lanesU[11] = ay1 ^ ((~ay2) & ay3)
            lanesU[12] = ay2 ^ ((~ay3) & ay4)
            lanesU[13] = ay3 ^ ((~ay4) & ay0)
            lanesU[14] = ay4 ^ ((~ay0) & ay1)
            ay0 = lanesU[15]
            ay1 = lanesU[16]
            ay2 = lanesU[17]
            ay3 = lanesU[18]
            ay4 = lanesU[19]
            lanesU[15] = ay0 ^ ((~ay1) & ay2)
            lanesU[16] = ay1 ^ ((~ay2) & ay3)
            lanesU[17] = ay2 ^ ((~ay3) & ay4)
            lanesU[18] = ay3 ^ ((~ay4) & ay0)
            lanesU[19] = ay4 ^ ((~ay0) & ay1)
            ay0 = lanesU[20]
            ay1 = lanesU[21]
            ay2 = lanesU[22]
            ay3 = lanesU[23]
            ay4 = lanesU[24]
            lanesU[20] = ay0 ^ ((~ay1) & ay2)
            lanesU[21] = ay1 ^ ((~ay2) & ay3)
            lanesU[22] = ay2 ^ ((~ay3) & ay4)
            lanesU[23] = ay3 ^ ((~ay4) & ay0)
            lanesU[24] = ay4 ^ ((~ay0) & ay1)
        }
    }

    func padding(_ totalBytes: Int, _ blockSize: Int) -> Bytes {
        let x = ((totalBytes + blockSize) / blockSize) * blockSize - totalBytes
        var b = Bytes(repeating: 0, count: x)
        b[0] = 0x06
        b[x - 1] |= 0x80
        return b
    }

    static func rotateLeft(_ x: Limb, _ n: Int) -> Limb {
        return (x << n) | (x >> (64 - n))
    }

}
