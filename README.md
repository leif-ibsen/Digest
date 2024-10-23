## Digest

The Digest package provides the following functionality:

* Base64 encoding of bytes to text strings and the reverse decoding
* Base64 PEM encoding and decoding typically used to encode and decode cryptographic keys
* Message Digest algorithms - SHA1, SHA2 and SHA3
* Extendable Output Functions - SHAKE and XOF
* Hash Based Message Authentication Codes - HMAC
* Key Derivation Functions - HKDF and X963KDF
* Mask Generation Function - MGF1

Digest requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

Its documentation is build with the DocC plugin and published on GitHub Pages at this location:

https://leif-ibsen.github.io/Digest/documentation/digest

The documentation is also available in the *Digest.doccarchive* file.

Please note that the random number functionality that used to be in the
Digest package, is now in the SwiftRandom package.
