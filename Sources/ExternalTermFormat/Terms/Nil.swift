public extension TermBuffer {
    /// Encodes an empty list.
    mutating func encodeNil() {
        append(.nil)
    }

    mutating func decodeNil() throws(TermDecodingError) {
        guard try kind() == .nil else { throw TermDecodingError.wrongTag }
        _ = try consume()
    }
}