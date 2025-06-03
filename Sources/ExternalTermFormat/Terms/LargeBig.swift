public extension TermBuffer {
    /// Encodes a LARGE_BIG_EXT term.
    /// | 1     | 4   | 1      | n                   |
    /// | ----- | --- | ------ | ------------------- |
    /// | `111` | `n` | `Sign` | `d(0)` ... `d(n-1)` |
    mutating func encodeLargeBig(_ value: Int) {
        append(.largeBig)  // 'o'
        let absValue = abs(value)
        let sign: UInt8 = value < 0 ? 1 : 0
        let bytes = withUnsafeBytes(of: absValue.littleEndian) { Array($0) }
        withUnsafeBytes(of: UInt32(bytes.count).bigEndian) {
            append(contentsOf: $0)
        }
        append(sign)
        append(contentsOf: bytes)
    }

    mutating func decodeLargeBig() throws(TermDecodingError) -> Int {
        guard try kind() == .largeBig else { throw TermDecodingError.wrongTag }
        _ = try consume()
        let byteCount = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
        let sign = try consume()
        guard sign == 0 || sign == 1 else {
            throw TermDecodingError.wrongTag
        }
        let bytes = try consume(Int(byteCount))
        var value: Int = 0
        for (i, byte) in bytes.enumerated() {
            value += Int(byte) << (8 * i)
        }
        return sign == 1 ? -value : value
    }
}