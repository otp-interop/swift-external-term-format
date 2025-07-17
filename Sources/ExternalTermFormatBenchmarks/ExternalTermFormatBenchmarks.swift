import ExternalTermFormat

@main
struct ExternalTermFormatBenchmarks {
    static func main() throws {
        try test([131, 97, 5]) // .smallInteger(5)

        let binary: [UInt8] = [131,116,0,0,0,9,119,1,99,107,0,13,48,50,102,104,50,48,51,106,102,48,50,57,51,
            119,1,102,119,5,102,97,108,115,101,119,1,98,70,64,52,124,89,108,77,151,87,
            119,1,97,97,10,119,1,107,98,49,228,9,208,119,1,100,108,0,0,0,4,97,32,98,0,0,
            165,112,107,0,4,51,53,50,51,97,234,106,119,1,101,116,0,0,0,2,119,1,114,98,0,
            0,16,249,119,1,103,107,0,5,102,119,101,102,119,119,1,110,119,4,116,114,117,
            101,119,1,122,119,3,110,105,108]
        let clock = ContinuousClock()
        print(try Term(parsing: binary))
        let start = clock.now
        for _ in 0..<1_000_000 {
            _ = try Term(parsing: binary) // .list([.smallAtomUTF8("hello"), .smallAtomUTF8("world")])
        }

        let duration = start.duration(to: .now)
        print("Swift:  \(duration.components.seconds * 1_000_000 + duration.components.attoseconds / 1_000_000_000_000) µs")
    }

    static func test(_ binary: [UInt8]) throws {
        print(try Term(parsing: binary))
    }
}

// 2715209 µs
//  494964 µs

// smallTuple([
//     .smallTuple([.smallAtomUTF8("ok"), .list([.smallTuple([.smallAtomUTF8("user"), .binary([67, 97, 114, 115, 111, 110])]),
//     .smallTuple([.smallAtomUTF8("age"), .smallInteger(29)])])]), .nil, .map([
//         MapPair(key: .smallAtomUTF8("active"), value: .smallAtomUTF8("true")),
//         MapPair(key: .smallAtomUTF8("name"), value: .binary([67, 97, 114, 115, 111, 110, 32, 75, 97, 116, 114, 105])),
//         MapPair(key: .smallAtomUTF8("score"), value: .newFloat([64, 88, 172, 204, 204, 204, 204, 205]))
//     ]),
//     .list([.smallInteger(1), .smallInteger(2), .smallInteger(3), .smallTuple([
//             .smallAtomUTF8("nested"),
//             .list([.smallAtomUTF8("tuple"), .smallAtomUTF8("with"), .smallAtomUTF8("lists")])
//         ]),
//         .nil
//     ]),
//     .binary([0, 1, 2, 3]),
//     .nil
// ])