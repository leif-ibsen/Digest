# About Message Digest

## Overview

Message digesting is a three step operation.

### Example

```swift
import Digest

// 1. create the message digest instance
let md = MessageDigest(.SHA3_224)

// 2. feed the data to digest in one or more steps
md.update([1, 2, 3])
md.update([4, 5, 6])

// 3. compute the digest
let digest1 = md.digest()

// The steps can be combined
let digest2 = MessageDigest(.SHA3_224).digest([1, 2, 3, 4, 5, 6])

print("digest1:", digest1)
print("digest2:", digest2)
```
giving:

```swift
digest1: [62, 55, 233, 98, 97, 184, 219, 20, 116, 115, 238, 1, 51, 166, 35, 107, 203, 162, 84, 97, 158, 122, 189, 59, 178, 19, 16, 201]
digest2: [62, 55, 233, 98, 97, 184, 219, 20, 116, 115, 238, 1, 51, 166, 35, 107, 203, 162, 84, 97, 158, 122, 189, 59, 178, 19, 16, 201]
```

