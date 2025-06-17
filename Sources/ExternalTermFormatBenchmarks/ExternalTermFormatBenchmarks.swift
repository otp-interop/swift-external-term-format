import ExternalTermFormat

@main
struct ExternalTermFormatBenchmarks {
    static func main() throws {
        try test([131, 97, 5]) // .smallInteger(5)

        let binary: [UInt8] = [131,104,6,104,2,119,2,111,107,108,0,0,0,2,104,2,119,4,117,115,101,114,109,0,
        0,0,6,67,97,114,115,111,110,104,2,119,3,97,103,101,97,29,106,116,0,0,0,3,119,
        6,97,99,116,105,118,101,119,4,116,114,117,101,119,4,110,97,109,101,109,0,0,0,
        12,67,97,114,115,111,110,32,75,97,116,114,105,119,5,115,99,111,114,101,70,64,
        88,172,204,204,204,204,205,108,0,0,0,5,97,1,97,2,97,3,104,2,119,6,110,101,
        115,116,101,100,108,0,0,0,3,119,5,116,117,112,108,101,119,4,119,105,116,104,
        119,5,108,105,115,116,115,106,109,0,0,0,4,0,1,2,3,106,110,13,0,210,10,63,78,
        238,224,115,195,246,15,233,142,1,119,10,115,109,97,108,108,95,97,116,111,109,
        119,8,85,84,70,56,65,116,111,109]
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

// 1920255 µs
//  579468 µs

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