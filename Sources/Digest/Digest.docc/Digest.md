# ``Digest``

Digest Utilities

## Overview

The Digest package provides the following functionality:

* Message Digest algorithms - SHA1, SHA2 and SHA3, please see <doc:AboutMD>
* Blake2 Cryptographic Hash and Message Authentication Code, please see <doc:AboutBLAKE>
* Extendable Output Functions - SHAKE and XOF, please see <doc:AboutXOF>
* Hash Based Message Authentication Codes - HMAC, please see <doc:AboutMA>
* Key Derivation Functions - HKDF and X963KDF, please see <doc:AboutKDF>
* Mask Generation Function - MGF1, please see <doc:AboutHMAC>
* Base64 encoding of bytes to text strings and the reverse decoding, please see <doc:AboutBase64>
* Base64 PEM encoding and decoding typically used to encode and decode cryptographic keys, please see <doc:AboutBase64>
* Conversion between byte arrays and hexadecimal strings, please see <doc:AboutConversion>

### Usage

To use Digest, in your project Package.swift file add a dependency like

```swift
dependencies: [
  package(url: "https://github.com/leif-ibsen/Digest", from: "1.11.0"),
]
```

Digest itself does not depend on other packages.

> Important:
Digest requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

## Topics

### Classes

- ``Digest/MessageDigest``
- ``Digest/Blake2``

### Structures

- ``Digest/SHAKE``
- ``Digest/XOF``
- ``Digest/HMAC``
- ``Digest/KDF``
- ``Digest/Base64``

### Type Aliases

- ``Digest/Byte``
- ``Digest/Bytes``

### Additional Information

- <doc:AboutMD>
- <doc:AboutBLAKE>
- <doc:AboutXOF>
- <doc:AboutMA>
- <doc:AboutKDF>
- <doc:AboutHMAC>
- <doc:AboutBase64>
- <doc:AboutConversion>
- <doc:References>
