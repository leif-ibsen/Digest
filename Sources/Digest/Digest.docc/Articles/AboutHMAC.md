# About Mask Generation

## Overview

The mask generation function MGF1 as specified in [RFC 8017], is a static method in the ``Digest/KDF`` structure.  
It generates a mask of a specified size from a specified message digest and seed.

### Example

```swift
import Digest

let mask = KDF.MGF1(.SHA1, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12)
print(mask)
```
giving:
```swift
[224, 166, 61, 124, 140, 77, 129, 205, 28, 5, 103, 191]
```

