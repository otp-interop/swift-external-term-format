public extension TermBuffer {
    /// Encodes a small tuple header.
    mutating func encodeSmallTupleHeader(
        arity: UInt8
    ) {
        append(.smallTuple)
        append(arity)
    }

    mutating func decodeSmallTupleHeader() throws(TermDecodingError) -> UInt8 {
        guard try kind() == .smallTuple else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return try consume()
    }
}