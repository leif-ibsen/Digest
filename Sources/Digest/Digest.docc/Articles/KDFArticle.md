# Key Derivation Functions

## 

A key derivation function generates a symmetric key from a shared secret. There are two key derivation functions:
* HKDF as specified in [RFC 5859]
* X963KDF as specified in [SEC 1].
Both are static methods in the KDF structure.

### Example:

```swift
import Digest

let key1 = KDF.HKDF(.SHA2_224, [1, 2, 3, 4, 5, 6, 7, 8], 12, [1, 2, 3], [])
print("HKDF key   ", key1)

let key2 = KDF.X963KDF(.SHA2_224, [1, 2, 3, 4, 5, 6, 7, 8], 12, [1, 2, 3])
print("X963KDF key", key2)
```
giving:
```swift
HKDF key    [209, 96, 93, 84, 150, 249, 149, 185, 105, 184, 47, 210]
X963KDF key [110, 88, 12, 176, 49, 119, 151, 82, 163, 233, 226, 9]
```
