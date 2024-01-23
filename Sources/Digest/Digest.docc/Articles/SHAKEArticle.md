# SHAKE and XOF

## 

SHAKE and XOF are extendable output functions which can generate output of any desired length based on a given seed.

### SHAKE 128 example:

```swift
import Digest

let shake = SHAKE(.SHAKE128)
shake.update([1, 2, 3])
print(shake.digest(25))
```
    
giving:

```swift
[218, 239, 167, 7, 93, 32, 41, 187, 214, 105, 12, 86, 166, 83, 123, 154, 218, 108, 92, 47, 146, 196, 24, 130, 197]
```

If you know you need 25 bytes of output, you must request them all at once,
*digest(12)* followed by *digest(13)* won't work, because the *digest* method resets *shake* to its original state.

### XOF 128 example:

```swift
import Digest

let xof = XOF(.XOF128, [1, 2, 3])
var z: Bytes = []
for _ in 0 ..< 25 {
    z += xof.read(1)
}
print(z)
```

giving:

```swift
[218, 239, 167, 7, 93, 32, 41, 187, 214, 105, 12, 86, 166, 83, 123, 154, 218, 108, 92, 47, 146, 196, 24, 130, 197]
```
XOF is similar to SHAKE, but as the examples show, the XOF *read* function can be called many times to accumulate the total amount of output.
XOF has no *update* method, the initial seed must be supplied in the constructor.
