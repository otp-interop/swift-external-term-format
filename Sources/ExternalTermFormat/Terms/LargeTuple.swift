public extension TermBuffer {
    /// Encodes a large tuple header.
    mutating func encodeLargeTupleHeader(
        arity: UInt32
    ) {
        append(.largeTuple)
        withUnsafeBytes(of: arity.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodeLargeTupleHeader() throws(TermDecodingError) -> UInt32 {
        guard try kind() == .largeTuple else { throw TermDecodingError.wrongTag }
        _ = try consume()
        
        return try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
    }
}