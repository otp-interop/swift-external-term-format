public extension TermBuffer {
    /// Encodes a SMALL_BIG_EXT term.
    /// | 1     | 1   | 1      | n                   |
    /// | ----- | --- | ------ | ------------------- |
    /// | `110` | `n` | `Sign` | `d(0)` ... `d(n-1)` |
    mutating func encodeSmallBig(_ value: Int) {
        append(.smallBig)  // 'n'
        let absValue = abs(value)
        let sign: UInt8 = value < 0 ? 1 : 0
        let bytes = withUnsafeBytes(of: absValue.littleEndian) { Array($0) }
        append(UInt8(bytes.count))
        append(sign)
        append(contentsOf: bytes)
    }

    mutating func decodeSmallBig() throws(TermDecodingError) -> Int {
        guard try kind() == .smallBig else {
            throw TermDecodingError.wrongTag
        }
        _ = try consume()
        let count = Int(try consume(1)[0])
        let sign = try consume(1)[0]
        let bytes = try consume(count)
        var value: Int = 0
        for (i, byte) in bytes.enumerated() {
            value |= Int(byte) << (i * 8)
        }
        return sign == 1 ? -value : value
    }
}