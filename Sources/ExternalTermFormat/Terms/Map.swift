public extension TermBuffer {
    /// Encodes a map header.
    mutating func encodeMapHeader(
        arity: UInt32
    ) {
        append(.map)
        withUnsafeBytes(of: arity.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodeMapHeader() throws(TermDecodingError) -> UInt32 {
        guard try kind() == .map else { throw TermDecodingError.wrongTag }
        _ = try consume()
        
        return try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
    }
}