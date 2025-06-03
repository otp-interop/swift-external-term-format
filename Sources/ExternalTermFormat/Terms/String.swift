public extension TermBuffer {
    /// Encodes a list of bytes.
    mutating func encodeString(
        _ characters: [UInt8]
    ) {
        append(.string)
        withUnsafeBytes(of: UInt16(characters.count).bigEndian) {
            append(contentsOf: $0)
        }
        append(contentsOf: characters)
    }

    mutating func decodeString() throws(TermDecodingError) -> [UInt8] {
        guard try kind() == .string else { throw TermDecodingError.wrongTag }
        _ = try consume()

        let count = try consume(2).withUnsafeBytes { UInt16(bigEndian: $0.load(as: UInt16.self)) }
        return try consume(Int(count))
    }
}