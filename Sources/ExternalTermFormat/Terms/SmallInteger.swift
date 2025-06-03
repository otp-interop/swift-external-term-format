public extension TermBuffer {
    /// Unsigned 8-bit integer
    mutating func encodeSmallInteger(_ value: UInt8) {
        append(.smallInteger)
        append(value)
    }

    mutating func decodeSmallInteger() throws(TermDecodingError) -> UInt8 {
        guard try kind() == .smallInteger else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return try consume()
    }
}