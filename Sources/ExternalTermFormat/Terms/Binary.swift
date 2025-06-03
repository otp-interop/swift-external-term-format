public extension TermBuffer {
    /// Encodes a binary.
    mutating func encodeBinary(
        _ data: [UInt8]
    ) {
        append(.binary)
        withUnsafeBytes(of: UInt32(data.count).bigEndian) {
            append(contentsOf: $0)
        }
        append(contentsOf: data)
    }

    mutating func decodeBinary() throws(TermDecodingError) -> [UInt8] {
        guard try kind() == .binary
        else { throw TermDecodingError.wrongTag }
        _ = try consume()
        let size = try consume(4).withUnsafeBytes {
            UInt32(bigEndian: $0.load(as: UInt32.self))
        }
        return try consume(Int(size))
    }
}