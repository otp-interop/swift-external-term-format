import Testing
import ExternalTermFormat

@Test func smallInteger() {
    let encoded: [UInt8] = [131, 97, 5]

    print(Term.smallAtomUTF8("hello, world!"))
}

// @Test func smallInteger() throws {
//     let encoded: [UInt8] = [131, 97, 5]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeSmallInteger() == 5)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeSmallInteger(5)

//     #expect(buffer.buffer == encoded)
// }

// @Test func binary() throws {
//     let encoded: [UInt8] = [131, 109, 0, 0, 0, 3, 1, 2, 3]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeBinary() == [1, 2, 3])

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeBinary([1, 2, 3])

//     #expect(buffer.buffer == encoded)
// }

// @Test func bitBinary() throws {
//     let encoded: [UInt8] = [131, 77, 0, 0, 0, 1, 3, 160]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeBitBinary() == (bits: 3, data: [160]))

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeBitBinary(bits: 3, data: [160])

//     #expect(buffer.buffer == encoded)
// }

// @Test func distributionHeader() throws {
//     let encoded: [UInt8] = [131, 68, 0]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeDistributionHeader() == 0)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeDistributionHeader()

//     #expect(buffer.buffer == encoded)
// }

// @Test func export() throws {
//     let encoded: [UInt8] = [131, 113, 119, 11, 69, 108, 105, 120, 105, 114, 46, 69, 110, 117, 109, 119, 3, 109, 97, 112, 97, 2]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeExport() == (module: "Elixir.Enum", function: "map", arity: 2))

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeExport(module: "Elixir.Enum", function: "map", arity: 2)

//     #expect(buffer.buffer == encoded)
// }

// @Test func float() throws {
//     let encoded: [UInt8] = [131, 70, 64, 9, 30, 184, 81, 235, 133, 31]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeFloat() == 3.14)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeFloat(3.14)

//     #expect(buffer.buffer == encoded)
// }

// @Test func function() throws {
//     let encoded: [UInt8] = [131, 112, 0, 0, 1, 53, 3, 155, 150, 1, 91, 207, 233, 28, 67, 173, 38, 99, 113,
//         23, 87, 162, 37, 0, 0, 0, 40, 0, 0, 0, 1, 119, 8, 101, 114, 108, 95, 101, 118,
//         97, 108, 97, 40, 98, 4, 220, 176, 10, 88, 119, 13, 110, 111, 110, 111, 100,
//         101, 64, 110, 111, 104, 111, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 104,
//         6, 97, 19, 116, 0, 0, 0, 0, 104, 2, 119, 5, 118, 97, 108, 117, 101, 113, 119,
//         6, 101, 108, 105, 120, 105, 114, 119, 18, 101, 118, 97, 108, 95, 108, 111, 99,
//         97, 108, 95, 104, 97, 110, 100, 108, 101, 114, 97, 2, 104, 2, 119, 5, 118, 97,
//         108, 117, 101, 113, 119, 6, 101, 108, 105, 120, 105, 114, 119, 21, 101, 118,
//         97, 108, 95, 101, 120, 116, 101, 114, 110, 97, 108, 95, 104, 97, 110, 100, 108,
//         101, 114, 97, 3, 116, 0, 0, 0, 0, 108, 0, 0, 0, 1, 104, 5, 119, 6, 99, 108, 97,
//         117, 115, 101, 97, 19, 108, 0, 0, 0, 3, 104, 3, 119, 3, 118, 97, 114, 97, 19,
//         119, 4, 95, 97, 64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 98,
//         64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 99, 64, 49, 106, 106,
//         108, 0, 0, 0, 1, 104, 3, 119, 5, 116, 117, 112, 108, 101, 97, 19, 108, 0, 0, 0,
//         3, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 97, 64, 49, 104, 3, 119,
//         3, 118, 97, 114, 97, 19, 119, 4, 95, 98, 64, 49, 104, 3, 119, 3, 118, 97, 114,
//         97, 19, 119, 4, 95, 99, 64, 49, 106, 106, 106]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     let function = try buffer.decodeFunction()
//     #expect(function.arity == 3)
//     #expect(function.module == "erl_eval")
//     #expect(function.pid.node == PID(node: "nonode@nohost", id: 0, serial: 0, creation: 0).node)
    
//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeFunction(arity: 3, uniq: [155, 150, 1, 91, 207, 233, 28, 67, 173, 38, 99, 113, 23, 87, 162, 37], index: 40, module: "erl_eval", oldIndex: 40, oldUniq: 81571850, pid: PID(node: "nonode@nohost", id: 0, serial: 0, creation: 0), freeVars: [[104, 6, 97, 19, 116, 0, 0, 0, 0, 104, 2, 119, 5, 118, 97, 108, 117, 101, 113, 119, 6, 101, 108, 105, 120, 105, 114, 119, 18, 101, 118, 97, 108, 95, 108, 111, 99, 97, 108, 95, 104, 97, 110, 100, 108, 101, 114, 97, 2, 104, 2, 119, 5, 118, 97, 108, 117, 101, 113, 119, 6, 101, 108, 105, 120, 105, 114, 119, 21, 101, 118, 97, 108, 95, 101, 120, 116, 101, 114, 110, 97, 108, 95, 104, 97, 110, 100, 108, 101, 114, 97, 3, 116, 0, 0, 0, 0, 108, 0, 0, 0, 1, 104, 5, 119, 6, 99, 108, 97, 117, 115, 101, 97, 19, 108, 0, 0, 0, 3, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 97, 64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 98, 64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 99, 64, 49, 106, 106, 108, 0, 0, 0, 1, 104, 3, 119, 5, 116, 117, 112, 108, 101, 97, 19, 108, 0, 0, 0, 3, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 97, 64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 98, 64, 49, 104, 3, 119, 3, 118, 97, 114, 97, 19, 119, 4, 95, 99, 64, 49, 106, 106, 106]])
    
//     #expect(buffer.buffer == encoded)
// }

// @Test func integer() throws {
//     let encoded: [UInt8] = [131, 98, 255, 255, 252, 0]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeInteger() == -1024)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeInteger(-1024)

//     #expect(buffer.buffer == encoded)
// }

// @Test func big() throws {
//     let encoded: [UInt8] = [131, 110, 8, 0, 0, 0, 0, 0, 0, 0, 0, 8]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeSmallBig() == 576460752303423488)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeSmallBig(576460752303423488)

//     #expect(buffer.buffer == encoded)
// }

// @Test func tuple() throws {
//     let encoded: [UInt8] = [131, 104, 3, 97, 1, 97, 2, 97, 3]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeSmallTupleHeader() == 3)
//     #expect(try buffer.decodeSmallInteger() == 1)
//     #expect(try buffer.decodeSmallInteger() == 2)
//     #expect(try buffer.decodeSmallInteger() == 3)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeSmallTupleHeader(arity: 3)
//     buffer.encodeSmallInteger(1)
//     buffer.encodeSmallInteger(2)
//     buffer.encodeSmallInteger(3)

//     #expect(buffer.buffer == encoded)
// }

// @Test func list() throws {
//     let encoded: [UInt8] = [131, 108, 0, 0, 0, 3, 119, 1, 97, 119, 1, 98, 119, 1, 99, 106]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeListHeader() == 3)
//     #expect(try buffer.decodeSmallAtomUTF8() == "a")
//     #expect(try buffer.decodeSmallAtomUTF8() == "b")
//     #expect(try buffer.decodeSmallAtomUTF8() == "c")

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeListHeader(arity: 3)
//     buffer.encodeSmallAtomUTF8("a")
//     buffer.encodeSmallAtomUTF8("b")
//     buffer.encodeSmallAtomUTF8("c")
//     buffer.encodeNil()

//     #expect(buffer.buffer == encoded)
// }

// @Test func map() throws {
//     let encoded: [UInt8] = [131, 116, 0, 0, 0, 2, 97, 1, 97, 2, 97, 3, 97, 4]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeMapHeader() == 2)
//     #expect(try buffer.decodeSmallInteger() == 1)
//     #expect(try buffer.decodeSmallInteger() == 2)
//     #expect(try buffer.decodeSmallInteger() == 3)
//     #expect(try buffer.decodeSmallInteger() == 4)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeMapHeader(arity: 2)
//     buffer.encodeSmallInteger(1)
//     buffer.encodeSmallInteger(2)
//     buffer.encodeSmallInteger(3)
//     buffer.encodeSmallInteger(4)

//     #expect(buffer.buffer == encoded)
// }

// @Test func nilCoding() throws {
//     let encoded: [UInt8] = [131, 106]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     try buffer.decodeNil()

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeNil()

//     #expect(buffer.buffer == encoded)
// }

// @Test func pid() throws {
//     let encoded: [UInt8] = [131, 88, 119, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115, 116, 0, 0, 0, 104, 0, 0, 0, 0, 0, 0, 0, 0]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodePID().node == PID(node: "nonode@nohost", id: 104, serial: 0, creation: 0).node)

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodePID(PID(node: "nonode@nohost", id: 104, serial: 0, creation: 0))

//     #expect(buffer.buffer == encoded)
// }

// @Test func port() throws {
//     let encoded: [UInt8] = [131, 120, 119, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodePort() == (node: "nonode@nohost", id: 0, creation: 0))

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodePort(node: "nonode@nohost", id: 0, creation: 0)

//     #expect(buffer.buffer == encoded)
// }

// @Test func reference() throws {
//     let encoded: [UInt8] = [131, 90, 0, 3, 119, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115, 116, 0, 0, 0, 0, 0, 1, 22, 124, 218, 72, 0, 5, 196, 59, 199, 159]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeReference() == (node: "nonode@nohost", creation: 0, id: [71292, 3662151685, 3292252063]))

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeReference(node: "nonode@nohost", creation: 0, id: [71292, 3662151685, 3292252063])

//     #expect(buffer.buffer == encoded)
// }

// @Test func smallAtomUTF8() throws {
//     let encoded: [UInt8] = [131, 119, 5, 104, 101, 108, 108, 111]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeSmallAtomUTF8() == "hello")

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeSmallAtomUTF8("hello")

//     #expect(buffer.buffer == encoded)
// }

// @Test func string() throws {
//     let encoded: [UInt8] = [131, 107, 0, 3, 97, 98, 99]

//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     #expect(try buffer.decodeString() == ["a" as Character, "b" as Character, "c" as Character].map(\.asciiValue))

//     buffer = TermBuffer()
//     buffer.encodeVersion()
//     buffer.encodeString(["a" as Character, "b" as Character, "c" as Character].compactMap(\.asciiValue))

//     #expect(buffer.buffer == encoded)
// }

// @Test func messageTest() throws {
//     let encoded: [UInt8] = [131, 68, 0, 104, 4, 97, 6, 88, 119, 13, 119, 101, 98, 64, 49, 50, 55, 46, 48, 46, 48, 46, 49, 0, 0, 0, 0, 0, 0, 0, 0, 104, 54, 130, 92, 119, 0, 119, 3, 102, 111, 111, 97, 5]
//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     print(try buffer.decodeDistributionHeader())
//     print(try buffer.decodeSmallTupleHeader())
//     print(try buffer.decodeSmallInteger())
//     print(try buffer.decodePID())
//     print(try buffer.decodeSmallAtomUTF8() == "")
//     print(try buffer.decodeSmallAtomUTF8())
//     print(try buffer.decodeSmallInteger())
// }

// @Test func skip() throws {
//     let encoded: [UInt8] = [131, 68, 0, 104, 4, 97, 6, 88, 119, 13, 119, 101, 98, 64, 49, 50, 55, 46, 48, 46, 48, 46, 49, 0, 0, 0, 0, 0, 0, 0, 0, 104, 54, 130, 92, 119, 0, 119, 3, 102, 111, 111, 97, 5]
//     var buffer = TermBuffer(encoded)
//     _ = try buffer.decodeVersion()
//     _ = try buffer.decodeDistributionHeader()
//     let controlMessageStart = buffer.index
//     try buffer.skip() // skip the control message tuple
//     let controlMessage = buffer.buffer[controlMessageStart..<buffer.index]
//     print(controlMessage)
//     print(buffer.buffer[buffer.index...])
// }