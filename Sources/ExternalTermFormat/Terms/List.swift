public extension TermBuffer {
    /// Encodes a list header.
    mutating func encodeListHeader(
        arity: UInt32
    ) {
        append(.list)
        withUnsafeBytes(of: arity.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodeListHeader() throws(TermDecodingError) -> UInt32 {
        guard try kind() == .list else { throw TermDecodingError.wrongTag }
        _ = try consume()
        
        return try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
    }
}