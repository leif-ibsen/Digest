# About Base64

## Overview

``Digest/Base64`` has static methods to encode bytes to a text string and to do the reverse decoding.

### Base64 example

```swift
import Digest

let b: Bytes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let b64 = Base64.encode(b)
print(b64)
print(Base64.decode(b64)!)
```

giving:

```swift
AAECAwQFBgcICQo=
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

### PEM example

```swift
import Digest

let pem =
"""
-----BEGIN PUBLIC KEY-----
MEAwEAYHKoZIzj0CAQYFK4EEAAEDLAAEA6txn7CCae0d9AiGj3Rk5m9XflTCB81oe1fKZi4F4oip
SF2u79k8TD5J
-----END PUBLIC KEY-----
"""
// ´pem´ happens to be the PEM encoding of a public key from the ´sect163k1´ elliptic curve domain

let der = Base64.pemDecode(pem, "PUBLIC KEY")!

// ´der´ is the ASN1 DER encoding of the key from which the key could be recreated
print(der)
```

giving:

```swift
[48, 64, 48, 16, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 5, 43, 129, 4, 0, 1, 3, 44, 0, 4, 3, 171, 113, 159, 176, 130, 105, 237, 29, 244, 8, 134, 143, 116, 100, 230, 111, 87, 126, 84, 194, 7, 205, 104, 123, 87, 202, 102, 46, 5, 226, 136, 169, 72, 93, 174, 239, 217, 60, 76, 62, 73]
```
