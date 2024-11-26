# About Blake2

## Overview

``Digest/Blake2`` implements the BLAKE2b cryptographic hash function.

A Blake2 instance is created with the desired digest length - [1 .. 64] - as parameter. One may also supply

* an optional key - a byte array of up to 64 bytes
* an optional salt value - a byte array of up to 16 bytes
* an optional personalisation value - a byte array of up to 16 bytes

### Example 1

```swift
import Digest

let bl = Blake2(digestLength: 20)
bl.update([1, 2, 3])
bl.update([4, 5, 6])
let x = bl.digest()
print(x)

// Alternatively

print(Blake2(digestLength: 20).digest([1, 2, 3, 4, 5, 6]))
```

giving:

```swift
[97, 228, 27, 214, 36, 254, 242, 119, 2, 242, 220, 143, 95, 146, 220, 243, 8, 145, 147, 243]
[97, 228, 27, 214, 36, 254, 242, 119, 2, 242, 220, 143, 95, 146, 220, 243, 8, 145, 147, 243]
```

### Example 2

```swift
import Digest

let bl = Blake2(digestLength: 20, key: [1, 2, 3], salt: [4, 5, 6], personal: [7, 8, 9])
bl.update([1, 2, 3])
bl.update([4, 5, 6])
let x = bl.digest()
print(x)

// Alternatively

print(Blake2(digestLength: 20, key: [1, 2, 3], salt: [4, 5, 6], personal: [7, 8, 9]).digest([1, 2, 3, 4, 5, 6]))
```

giving:

```swift
[188, 179, 185, 208, 136, 221, 255, 236, 134, 144, 205, 126, 174, 125, 85, 57, 97, 157, 216, 138]
[188, 179, 185, 208, 136, 221, 255, 236, 134, 144, 205, 126, 174, 125, 85, 57, 97, 157, 216, 138]
```
