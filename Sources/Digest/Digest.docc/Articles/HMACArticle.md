# HMAC

## 

Using ``Digest/HMAC`` to generate a message authentication code is a three step operation.

### Example

```swift
import Digest

// 1. create the HMAC instance with a specified message digest and secret key
let hmac = HMAC(.SHA2_256, [1, 2, 3, 4, 5, 6])

// 2. update the HMAC instance with the text to compute the code for
hmac.update([1, 2, 3])

// 3. compute the code
let code = hmac.compute()
print(code)
```
giving:
```swift
[165, 171, 8, 206, 249, 140, 216, 179, 11, 30, 187, 136, 116, 132, 141, 34, 66, 169, 175, 107, 27, 31, 84, 190, 108, 60, 61, 222, 233, 97, 15, 247]
```
