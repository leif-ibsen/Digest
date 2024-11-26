//
//  File.swift
//  Digest
//
//  Created by Leif Ibsen on 17/11/2024.
//

/// The Blake2 class
public class Blake2 {
    
    static let IV: Limbs = [
        0x6a09e667f3bcc908,
        0xbb67ae8584caa73b,
        0x3c6ef372fe94f82b,
        0xa54ff53a5f1d36f1,
        0x510e527fade682d1,
        0x9b05688c2b3e6c1f,
        0x1f83d9abfb41bd6b,
        0x5be0cd19137e2179
    ]

    static let SIGMA: [[Int]] = [
        [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15],
        [14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3],
        [11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4],
        [ 7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8],
        [ 9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13],
        [ 2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9],
        [12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11],
        [13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10],
        [ 6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5],
        [10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13,  0],
        [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15],
        [14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3]
    ]

    struct blakeConText {
        var b: Bytes
        var h: Limbs
        var t: Limbs
        var c: Int
        
        init( _ size: Int, _ key: Bytes, _ salt: Bytes, _ personal: Bytes) {
            self.b = Bytes(repeating: 0, count: 128)
            self.h = Limbs(IV[0 ..< 8])
            self.h[0] ^= 0x01010000 ^ (Limb(key.count) << 8) ^ Limb(size)
            for i in 0 ..< salt.count {
                if i < 8 {
                    h[4] ^= Limb(salt[i]) << (i << 3)
                } else {
                    h[5] ^= Limb(salt[i]) << ((i - 8) << 3)
                }
            }
            for i in 0 ..< personal.count {
                if i < 8 {
                    h[6] ^= Limb(personal[i]) << (i << 3)
                } else {
                    h[7] ^= Limb(personal[i]) << ((i - 8) << 3)
                }
            }
            self.t = [0, 0]
            for i in 0 ..< key.count {
                self.b[i] = key[i]
            }
            self.c = key.count == 0 ? 0 : 128
        }
    }

    let key: Bytes
    let salt: Bytes
    let personal: Bytes
    var ctx: blakeConText

    /// Constructs a Blake2 instance
    ///
    /// - Precondition: `digestLength` is positive and less than or equal to 64
    /// - Precondition: `key.count` is less than or equal to 64
    /// - Precondition: `salt.count` is less than or equal to 16
    /// - Precondition: `personal.count` is less than or equal to 16
    /// - Parameters:
    ///   - digestLength: The message digest length
    ///   - key: The key bytes, default is an empty array
    ///   - salt: The salt bytes, default is an empty array
    ///   - personal: The personalization bytes, default is an empty array
    public init(digestLength: Int, key: Bytes = [], salt: Bytes = [], personal: Bytes = []) {
        precondition(0 < digestLength && digestLength <= 64)
        precondition(key.count <= 64)
        precondition(salt.count <= 16)
        precondition(personal.count <= 16)
        self.digestLength = digestLength
        self.key = key
        self.salt = salt
        self.personal = personal
        self.ctx = blakeConText(self.digestLength, self.key, self.salt, self.personal)
    }
    
    
    // MARK: Stored properties
    
    /// The digest length
    public internal(set) var digestLength: Int


    // MARK: Methods

    /// Digests more data
    ///
    /// - Parameters:
    ///   - data: Data to digest
    public func update(_ data: Bytes) {
        for i in 0 ..< data.count {
            if self.ctx.c == 128 {
                self.ctx.t[0] &+= Limb(self.ctx.c)
                if self.ctx.t[0] < self.ctx.c {
                    self.ctx.t[1] &+= 1
                }
                self.compress(false)
                self.ctx.c = 0
            }
            self.ctx.b[self.ctx.c] = data[i]
            self.ctx.c += 1
        }
    }

    /// Computes the digest value and resets `self` to its original state
    ///
    /// - Parameters:
    ///   - data: Data to digest before the digest value is computed, default is an empty array
    /// - Returns: The digest value
    public func digest(_ data: Bytes = []) -> Bytes {
        self.update(data)
        let x = self.final()
        self.reset()
        return x
    }
    
    /// Resets `self` to its original state
    public func reset() {
        self.ctx = blakeConText(self.digestLength, self.key, self.salt, self.personal)
    }
    
    func final() -> Bytes {
        self.ctx.t[0] &+= Limb(self.ctx.c)
        if self.ctx.t[0] < self.ctx.c {
            self.ctx.t[1] &+= 1
        }
        while self.ctx.c < 128 {
            self.ctx.b[self.ctx.c] = 0
            self.ctx.c += 1
        }
        self.compress(true)
        return limbs2bytes(self.ctx.h, self.digestLength)
    }
    
    func rotate(_ x: Limb, _ n: Int) -> Limb {
        return (x >> n) ^ (x << (64 - n))
    }

    func G(_ v: inout Limbs, _ a: Int, _ b: Int, _ c: Int, _ d: Int, _ x: Limb, _ y: Limb) {
        v[a] = v[a] &+ v[b] &+ x
        v[d] = rotate(v[d] ^ v[a], 32)
        v[c] = v[c] &+ v[d]
        v[b] = rotate(v[b] ^ v[c], 24)
        v[a] = v[a] &+ v[b] &+ y
        v[d] = rotate(v[d] ^ v[a], 16)
        v[c] = v[c] &+ v[d]
        v[b] = rotate(v[b] ^ v[c], 63)
    }

    func bytes2limb(_ b: Bytes, _ n: Int) -> Limb {
        var x = Limb(0)
        for i in 0 ..< 8 {
            x |= Limb(b[i + n]) << (i << 3)
        }
        return x
    }

    func limbs2bytes(_ l: Limbs, _ n: Int) -> Bytes {
        var x = Bytes(repeating: 0, count: n)
        for i in 0 ..< n {
            x[i] = Byte(l[i >> 3] >> (8 * (i & 7)) & 0xff)
        }
        return x
    }

    func compress(_ last: Bool) {
        var v = Limbs(repeating: 0, count: 16)
        for i in 0 ..< 8 {
            v[i] = self.ctx.h[i]
            v[i + 8] = Blake2.IV[i]
        }
        v[12] ^= self.ctx.t[0]
        v[13] ^= self.ctx.t[1]
        if last {
            v[14] ^= 0xffffffffffffffff
        }
        var m = Limbs(repeating: 0, count: 16)
        for i in 0 ..< 16 {
            m[i] = bytes2limb(self.ctx.b, i << 3)
        }
        for i in 0 ..< 12 {
            let s = Blake2.SIGMA[i]
            G(&v, 0, 4,  8, 12, m[s[0]], m[s[1]])
            G(&v, 1, 5,  9, 13, m[s[2]], m[s[3]])
            G(&v, 2, 6, 10, 14, m[s[4]], m[s[5]])
            G(&v, 3, 7, 11, 15, m[s[6]], m[s[7]])
            G(&v, 0, 5, 10, 15, m[s[8]], m[s[9]])
            G(&v, 1, 6, 11, 12, m[s[10]], m[s[11]])
            G(&v, 2, 7,  8, 13, m[s[12]], m[s[13]])
            G(&v, 3, 4,  9, 14, m[s[14]], m[s[15]])
        }
        for i in 0 ..< 8 {
            self.ctx.h[i] ^= v[i] ^ v[i + 8]
        }
    }

}

