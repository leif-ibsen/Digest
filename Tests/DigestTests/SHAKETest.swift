//
//  SHAKETest.swift
//  
//
//  Created by Leif Ibsen on 28/11/2023.
//

import XCTest
@testable import Digest

final class SHAKETest: XCTestCase {

    // NIST test vectors

    struct testStruct {
        let seed: Bytes
        let output: Bytes

        init(seed: String, output: String) {
            self.seed = Base64.hex2bytes(seed)!
            self.output = Base64.hex2bytes(output)!
        }
    }
    
    let tests128: [testStruct] = [
        testStruct(
            seed: "",
            output: "7f9c2ba4e88f827d616045507605853e"
        ),
        testStruct(
            seed: "0e",
            output: "fa996dafaa208d72287c23bc4ed4bfd5"
        ),
        testStruct(
            seed: "d9e8",
            output: "c7211512340734235bb8d3c4651495aa"
        ),
        testStruct(
            seed: "29d97029326800f97f8db0d37078f91c6e3cb21e2033e099e29ecf7a738d62eaedffa78afb49aefd46bc9ca83082fbb5c5",
            output: "e087f5cc78aef2d5e3ec450d2270458b"
        ),
        testStruct(
            seed: "f322a6524f46c88053d6864062f67e8b29efeb80d48c77f182c45121f69880cc8f3f77687a81e9ab2661de4df8fe070f41bb",
            output: "b24fa4c9668707961e846e2d34542140"
        ),
        testStruct(
            seed: "a6fe00064257aa318b621c5eb311d32bb8004c2fa1a969d205d71762cc5d2e633907992629d1b69d9557ff6d5e8deb454ab00f6e497c89a4fea09e257a6fa2074bd818ceb5981b3e3faefd6e720f2d1edd9c5e4a5c51e5009abf636ed5bca53fe159c8287014a1bd904f5c8a7501625f79ac81eb618f478ce21cae6664acffb30572f059e1ad0fc2912264e8f1ca52af26c8bf78e09d75f3dd9fc734afa8770abe0bd78c90cc2ff448105fb16dd2c5b7edd8611a62e537db9331f5023e16d6ec150cc6e706d7c7fcbfff930c7281831fd5c4aff86ece57ed0db882f59a5fe403105d0592ca38a081fed84922873f538ee774f13b8cc09bd0521db4374aec69f4bae6dcb66455822c0b84c91a3474ffac2ad06f0a4423cd2c6a49d4f0d6242d6a1890937b5d9835a5f0ea5b1d01884d22a6c1718e1f60b3ab5e232947c76ef70b344171083c688093b5f1475377e3069863",
            output: "3109d9472ca436e805c6b3db2251a9bc"
        ),
        testStruct(
            seed: "49d81708d86cd59dea0ac2c1017a9712d6dffb754dde0b57a9023a39fc5f5b6be276fc176f59f6826610428fac3a0e85fcf71011db061b8fcf2bf085ccd45670effb6dc46f4e3f2ed08e981c5935187fc95b86cf46da675096b1cf9591a67842d6301116be93d8288e4d6b70f1b1db8aa5d203b774a21825665b8170351ee86801da91154570eaf80a1564945af7822df8232fd04ea65593a7f2ab1e9e84cf6ad6c494c9ec2d9d27aaad2b8f7e4f33f12a17b422bc2d4724c13ff8a8b62054d1bfb5c33b9c11183cd8df67694300165ca37637b5a781155f1c070d156339a0242374c6723b6584bffb71c02b935455f8cb086392f5e8e8cc2015956d8f19daeb6aca4476b27108387a2ce0dc5591154d0b94ddc090abe8f4363036b821062baffb7fe550ea7dcd30bfd86c84710081e1c9e450475e123c5ec41f98ff0149bbf6405b5207cad1fb2f313d0f2bcee9be3f6ebe623049640d9234ab644a172ab14ba02633a339b5b9bb38226fda5694f7ec63ebbb8238eb8219ec9c429f4bf0353383a72f2d21702f5e3c513499f04852710f33044512edc47a56bad90885e5713851a7efac694b869fa590076e844ff757d95de581c1b3fa3dd8ccd28cad4f8ae173ee1b28f98ee606dca89063fbef0f262b33053f2c854debdc9cd433ab77abb64f445aa9b981761c4761767f3b71c2646c7b0d873baae50bc9f0",
            output: "c609be05458f7ab33e7b6b54bc6e8999"
        ),
    ]

    let tests256: [testStruct] = [
        testStruct(
            seed: "",
            output: "46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762f"
        ),
        testStruct(
            seed: "0f",
            output: "aabb07488ff9edd05d6a603b7791b60a16d45093608f1badc0c9cc9a9154f215"
        ),
        testStruct(
            seed: "0dc1",
            output: "8e2df9d379bb034aee064e965f960ebb418a9bb535025fb96427f678cf207877"
        ),
        testStruct(
            seed: "999cd1673395cb04fc9bd7cd1eff8b4c0b3c0b6c113734de2ec51abc256eb56cd171d7c8ba07617be6ecb7aef21c71e561",
            output: "204b00fa02d648c19e3ab0638c24f3c4e9ba194e769d6d7efd64ec363fef5a72"
        ),
        testStruct(
            seed: "be6d8bdd535df0563225ac28ef979acfe62f98c27f46e94cb189d897c5aa9e0a5d5586d4b4664fc92759d26ef501e54f437d",
            output: "76e0c751292827d2d7580dbf73f62a11430ab12bdaf9c5104d39a7c8746338b6"
        ),
        testStruct(
            seed: "dc5a100fa16df1583c79722a0d72833d3bf22c109b8889dbd35213c6bfce205813edae3242695cfd9f59b9a1c203c1b72ef1a5423147cb990b5316a85266675894e2644c3f9578cebe451a09e58c53788fe77a9e850943f8a275f830354b0593a762bac55e984db3e0661eca3cb83f67a6fb348e6177f7dee2df40c4322602f094953905681be3954fe44c4c902c8f6bba565a788b38f13411ba76ce0f9f6756a2a2687424c5435a51e62df7a8934b6e141f74c6ccf539e3782d22b5955d3baf1ab2cf7b5c3f74ec2f9447344e937957fd7f0bdfec56d5d25f61cde18c0986e244ecf780d6307e313117256948d4230ebb9ea62bb302cfe80d7dfebabc4a51d7687967ed5b416a139e974c005fff507a96",
            output: "2bac5716803a9cda8f9e84365ab0a681327b5ba34fdedfb1c12e6e807f45284b"
        ),
        testStruct(
            seed: "16caf60da14b4fa9174a6d40c23cff93ed8fc9279990f749718db1500036ef2222498ffab86fa568a0611299e54e58d83281ac558d3f4d2541ee158b1c7d4d76dbffc64ae39925e3329f7fd894fa26fc1acdc22bc858a3438e1c55707a3f75ad2b33c48789937a24b34ddd85390611088cba3231b2a3a0a93e5d9a8780470fcff92cb03811234a330db353283b3bc3036f9125efb3eaed613bfa0c59975cc2e52c33b3e6e5123e1626190a4a0261e1f5ad9bc2ee34f331736b3bd26d274536f5ae90f5186c27fdd7e8c72972f64016e72d1d32b59b8715e5b867154b99cb140a668b9d560e2c307e3904d9297f9f07dfd7629ccc526e41c109c8fc7c53b604293c6cd42933e77e11031a42f605485fe893b129bcbf705c0f45a4b087bfcead5c187ac1174322909a2d4f8b61f001c4074951000c4c550ed5564458f444dab8aae2fe8daaa6a30d209fecddf2a893df46e18b4b4460e4011d23f01d4c49a4cc1c82405f6ac5339eac41385f3295c657ac43a72fed62e6daee94ef271638f292b8e18860de0699eb45fb7d3aa81f61d44158edd68ebc244451918b",
            output: "21a48efd949c3f785179a0e340756a23f77d29a7625229a71a05731c7fbd5aa9"
        ),
    ]

    func test128() throws {
        let shake = SHAKE(.SHAKE128)
        for t in tests128 {
            shake.update(t.seed)
            let X = shake.digest(t.output.count)
            XCTAssertEqual(X, t.output)
            shake.update(t.seed)
            let x = shake.digest(t.output.count / 2)
            XCTAssertEqual(x, Bytes(X[0 ..< t.output.count / 2]))
        }
    }
    
    func test256() throws {
        let shake = SHAKE(.SHAKE256)
        for t in tests256 {
            shake.update(t.seed)
            let X = shake.digest(t.output.count)
            XCTAssertEqual(X, t.output)
            shake.update(t.seed)
            let x = shake.digest(t.output.count / 2)
            XCTAssertEqual(x, Bytes(X[0 ..< t.output.count / 2]))
        }
    }
    
}
