# About Conversion

## Overview

``Digest/Base64`` has two static methods to convert a byte array to a hexadecimal string and to do the reverse conversion.

### Example

```swift
import Digest

let b: Bytes = [22, 247, 63, 254, 6, 115, 204, 153, 146]
let s = Base64.bytes2hex(b)
print(s)
print(Base64.hex2bytes(s)!)
```

giving:

```swift
16f73ffe0673cc9992
[22, 247, 63, 254, 6, 115, 204, 153, 146]
```

