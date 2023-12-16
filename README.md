<h2><b>Digest</b></h2>
<h3><b>Contents:</b></h3>
<ul>
<li><a href="#use">Usage</a></li>
<li><a href="#md">Message Digest</a></li>
<li><a href="#xof">SHAKE and XOF</a></li>
<li><a href="#hmac">HMAC</a></li>
<li><a href="#key">Key Derivation Functions</a></li>
<li><a href="#mask">Mask Generation Function</a></li>
<li><a href="#dep">Dependencies</a></li>
<li><a href="#ref">References</a></li>
</ul>
The Digest package provides the following functionality:
<ul>
<li>Message Digest algorithms - SHA1, SHA2 and SHA3</li>
<li>Extendable Output Functions - SHAKE and XOF</a></li>
<li>Hash Based Message Authentication Codes - HMAC</li>
<li>Key Derivation Functions - HKDF and X963KDF</a></li>
<li>Mask Generation Function - MGF1</a></li>
</ul>

<h2 id="use"><b>Usage</b></h2>
In your project Package.swift file add a dependency like<br/>

	  dependencies: [
	  .package(url: "https://github.com/leif-ibsen/Digest", from: "1.1.0"),
	  ]
Digest requires Swift 5.0. It also requires that the Int and UInt types be 64 bit types.
<h2 id="md"><b>Message Digest</b></h2>
Message digesting is a three step operation.<br/>
Example:
    
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
    
giving:

    digest1: [62, 55, 233, 98, 97, 184, 219, 20, 116, 115, 238, 1, 51, 166, 35, 107, 203, 162, 84, 97, 158, 122, 189, 59, 178, 19, 16, 201]
    digest2: [62, 55, 233, 98, 97, 184, 219, 20, 116, 115, 238, 1, 51, 166, 35, 107, 203, 162, 84, 97, 158, 122, 189, 59, 178, 19, 16, 201]

<h2 id="xof"><b>SHAKE and XOF</b></h2>
SHAKE and XOF are extendable output functions which can generate output of any desired length based on a given input.<br/>
SHAKE 128 example:

    import Digest
    
    let shake = SHAKE(.SHAKE128)
    shake.update([1, 2, 3])
    print(shake.digest(25))
    
giving:

    [218, 239, 167, 7, 93, 32, 41, 187, 214, 105, 12, 86, 166, 83, 123, 154, 218, 108, 92, 47, 146, 196, 24, 130, 197]

If you know you need 25 bytes of output, you must request them all at once,
*digest(12)* followed by *digest(13)* won't work, because the *digest* method resets *shake* to its original state.

XOF 128 example:

    import Digest
    
    let xof = XOF(.XOF128, [1, 2, 3])
    var z: Bytes = []
    for _ in 0 ..< 25 {
        z += xof.read(1)
    }
    print(z)

giving:

    [218, 239, 167, 7, 93, 32, 41, 187, 214, 105, 12, 86, 166, 83, 123, 154, 218, 108, 92, 47, 146, 196, 24, 130, 197]

XOF is similar to SHAKE, but as the examples show, the XOF *read* function can be called many times to accumulate the total amount of output.
XOF has no *update* method, the initial seed must be supplied in the constructor.
<h2 id="hmac"><b>HMAC</b></h2>
Using HMAC to generate a message authentication code is a three step operation.<br/>
Example:

    import Digest

    // 1. create the HMAC instance with a specified message digest and secret key
    let hmac = HMAC(.SHA2_256, [1, 2, 3, 4, 5, 6])

    // 2. update the HMAC instance with the text to compute the code for
    hmac.update([1, 2, 3])

    // 3. compute the code
    let code = hmac.compute()
    print(code)
    
giving:

    [165, 171, 8, 206, 249, 140, 216, 179, 11, 30, 187, 136, 116, 132, 141, 34, 66, 169, 175, 107, 27, 31, 84, 190, 108, 60, 61, 222, 233, 97, 15, 247]

<h2 id="key"><b>Key Derivation Functions</b></h2>
A key derivation function generates a symmetric key from a shared secret. There are two key derivation functions: HKDF as specified in [RFC 5859]
and X963KDF as specified in [SEC 1]. Both are static methods in the KDF structure.<br/>
Example:

    import Digest

    let key1 = KDF.HKDF(.SHA2_224, [1, 2, 3, 4, 5, 6, 7, 8], 12, [1, 2, 3], [])
    print("HKDF key   ", key1)

    let key2 = KDF.X963KDF(.SHA2_224, [1, 2, 3, 4, 5, 6, 7, 8], 12, [1, 2, 3])
    print("X963KDF key", key2)

giving:

    HKDF key    [209, 96, 93, 84, 150, 249, 149, 185, 105, 184, 47, 210]
    X963KDF key [110, 88, 12, 176, 49, 119, 151, 82, 163, 233, 226, 9]

<h2 id="mask"><b>Mask Generation Function</b></h2>
The mask generation function MGF1 as specified in [RFC 8017], is a static method in the KDF structure.
It generates a mask of a specified size from a specified message digest and seed.<br/>
Example:

    import Digest
    
    let mask = KDF.MGF1(.SHA1, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12)
    print(mask)

giving:

    [224, 166, 61, 124, 140, 77, 129, 205, 28, 5, 103, 191]

<h2 id="dep"><b>Dependencies</b></h2>
The Digest package does not depend on other packages.
<h2 id="ref"><b>References</b></h2>

Algorithms from the following RFC's have been used in the implementation.

<ul>
<li>[FIPS 180] - FIPS PUB 180-4: Secure Hash Standard (SHS), August 2015</li>
<li>[FIPS 198] - FIPS PUB 198-1: The Keyed-Hash Message Authentication Code, July 2008</li>
<li>[FIPS 202] - FIPS PUB 202: SHA-3 Standard: Permutation Based Hash and Extendable-Output Functions, August 2015</li>
<li>[RFC 3174] - US Secure Hash Algoritm 1 (SHA1), September 2001</li>
<li>[RFC 5869] - HMAC-based Extract-and-Expand Key Derivation Function (HKDF), May 2010</li>
<li>[RFC 8017] - RSA Cryptography Specification Version 2.2, November 2016</li>
<li>[SEC 1]    - SEC 1: Elliptic Curve Cryptography, Certicom Corp, May 2009</li>
</ul>
