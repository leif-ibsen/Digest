//
//  File.swift
//  
//
//  Created by Leif Ibsen on 06/09/2024.
//

import Foundation

/// The Base64 structure
public struct Base64 {
    
    static let base64chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                        "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                        "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                        "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"]

    private init() {
        // Not meant to be instantiated
    }


    // MARK: Static Methods

    /// Base64 encodes a byte array
    ///
    /// - Precondition: `linesize` is positive and a multiplum of 4
    /// - Parameters:
    ///   - input: Bytes to encode
    ///   - linesize: Number of characters per line, default is 76
    /// - Returns: The Base64 encoding of `input`
    public static func encode(_ input: Bytes, _ linesize: Int = 76) -> String {
        precondition(linesize > 0 && linesize % 4 == 0)
        var base64 = ""
        var i = 0
        var k = 0
        var bbb = Bytes(repeating: 0, count: 3)
        for b in input {
            bbb[i] = b
            i += 1
            if i == 3 {
                if k == linesize {
                    base64 += "\n"
                    k = 0
                }
                base64 += base64chars[Int(bbb[0] >> 2)]
                base64 += base64chars[Int(((bbb[0] & 0x03) << 4) | (bbb[1] >> 4))]
                base64 += base64chars[Int(((bbb[1] & 0x0f) << 2) | (bbb[2] >> 6))]
                base64 += base64chars[Int(bbb[2] & 0x3f)]
                i = 0
                k += 4
            }
        }
        if k == linesize && i > 0 {
            base64 += "\n"
        }
        if i == 1 {
            base64 += base64chars[Int(bbb[0] >> 2)]
            base64 += base64chars[Int((bbb[0] & 0x03) << 4)]
            base64 += "="
            base64 += "="
        } else if i == 2 {
            base64 += base64chars[Int(bbb[0] >> 2)]
            base64 += base64chars[Int(((bbb[0] & 0x03) << 4) | (bbb[1] >> 4))]
            base64 += base64chars[Int((bbb[1] & 0x0f) << 2)]
            base64 += "="
        }
        return base64
    }

    /// Base64 decodes a string
    ///
    /// - Parameters:
    ///   - input: String to decode
    /// - Returns: The Base64 decoding of `input` or `nil` if the input is malformed
    public static func decode(_ input: String) -> Bytes? {
        var bytes: Bytes = []
        var eq = 0
        var i = 0
        var x = 0
        var bbbb = Bytes(repeating: 0, count: 4)
        for s in input {
            x = Int(s.unicodeScalars.first!.value)
            switch x {
            case 65...90: // A .. Z
                if eq > 0 {
                    return nil
                }
                x -= 65
            case 97...122: // a .. z
                if eq > 0 {
                    return nil
                }
                x -= 71
            case 48...57: // 0 .. 9
                if eq > 0 {
                    return nil
                }
                x += 4
            case 43: // +
                if eq > 0 {
                    return nil
                }
                x = 62
            case 47: // /
                if eq > 0 {
                    return nil
                }
                x = 63
            case 61: // =
                eq += 1
                if eq > 2 {
                    return nil
                }
                x = 0
            case 10:
                continue
            case 13:
                continue
            default:
                return nil
            }
            bbbb[i] = Byte(x)
            i += 1
            if i == 4 {
                bytes.append((bbbb[0] << 2) | (bbbb[1] >> 4))
                if eq < 2 {
                    bytes.append((bbbb[1] << 4) | (bbbb[2] >> 2))
                    if eq < 1 {
                        bytes.append((bbbb[2] << 6) | bbbb[3])
                    }
                }
                i = 0
            }
        }
        return i > 0 ? nil : bytes
    }
    
    /// PEM encodes a byte array
    ///
    /// - Precondition: `linesize` is positive and a multiplum of 4
    /// - Parameters:
    ///   - input: Bytes to encode
    ///   - pem: The PEM header- and footer string
    ///   - linesize: Number of characters per line, default is 76
    /// - Returns: The Base64 PEM encoding of `input`
    public static func pemEncode(_ input: Bytes, _ pem: String, _ linesize: Int = 76) -> String {
        return "-----BEGIN " + pem + "-----\n" + encode(input, linesize) + "\n-----END " + pem + "-----"
    }

    /// PEM decodes a string
    ///
    /// - Parameters:
    ///   - input: String to decode
    ///   - pem: The expected PEM header- and footer string
    /// - Returns: The Base64 PEM decoding of `input` or `nil` if the input is malformed
    public static func pemDecode(_ input: String, _ pem: String) -> Bytes? {
        let parts = input.components(separatedBy: "-----")
        guard parts.count == 5 && parts[1] == "BEGIN " + pem && parts[3] == "END " + pem else {
            return nil
        }
        return decode(parts[2])
    }

    /// Converts a hexadecimal string to the corresponding byte array
    ///
    /// - Parameters:
    ///   - hex: A string containing an even number of hexadecimal digits - `0..9`, `a..f`, `A..F`
    /// - Returns: The byte array corresponding to `hex` or `nil` if the input is malformed
    public static func hex2bytes(_ hex: String) -> Bytes? {
        guard hex.count & 1 == 0 else {
            return nil
        }
        var b: Bytes = []
        var odd = false
        var x = Byte(0)
        var y = Byte(0)
        for c in hex {
            switch c {
            case "0" ... "9":
                x = c.asciiValue! - 48
            case "a" ... "f":
                x = c.asciiValue! - 97 + 10
            case "A" ... "F":
                x = c.asciiValue! - 65 + 10
            default:
                return nil
            }
            if odd {
                b.append(y << 4 + x)
            } else {
                y = x
            }
            odd = !odd
        }
        return b
    }

    /// Converts a byte array to the corresponding hexadecimal string
    ///
    /// - Parameters:
    ///   - bytes: The byte array to convert
    ///   - lowerCase: If `true` use `a..f` else use `A..F`, default is `true`
    /// - Returns: The hexadecimal string corresponding to `bytes`
    public static func bytes2hex(_ bytes: Bytes, _ lowerCase: Bool = true) -> String {
        let hexDigits = lowerCase ?
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"] :
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        var hex = ""
        for b in bytes {
            hex.append(hexDigits[Int(b >> 4)])
            hex.append(hexDigits[Int(b & 0xf)])
        }
        return hex
    }

}
