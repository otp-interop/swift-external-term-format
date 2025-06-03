public extension TermBuffer {
    /// Signed 32-bit integer in big-endian format.
    mutating func encodeInteger(_ value: Int32) {
        append(.integer)
        withUnsafeBytes(of: value.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodeInteger() throws(TermDecodingError) -> Int32 {
        guard try kind() == .integer else { throw TermDecodingError.wrongTag }
        _ = try consume()

        return try consume(4).withUnsafeBytes { Int32(bigEndian: $0.load(as: Int32.self)) }
    }
}