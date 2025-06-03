public extension TermBuffer {
    /// Encodes a NEW_FLOAT_EXT term.
    /// A finite float is stored as 8 bytes in big-endian IEEE format.
    mutating func encodeFloat(_ value: Double) {
        append(.float)  // 'F'
        withUnsafeBytes(of: value.bitPattern.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodeFloat() throws(TermDecodingError) -> Double {
        guard try kind() == .float else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return try consume(8).withUnsafeBytes {
            Double(bitPattern: UInt64(bigEndian: $0.load(as: UInt64.self)))
        }
    }
}