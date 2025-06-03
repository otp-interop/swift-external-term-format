public extension TermBuffer {
    /// Encodes a bit binary term whose length in bits doesn't have to be a multiple of 8.
    /// The bits field is the number of bits (1-8) that are used in the last byte in the data field.
    mutating func encodeBitBinary(bits: UInt8, data: [UInt8]) {
        append(.bitBinary)  // 'M'
        withUnsafeBytes(of: UInt32(data.count).bigEndian) {
            append(contentsOf: $0)
        }
        append(bits)
        append(contentsOf: data)
    }

    mutating func decodeBitBinary() throws(TermDecodingError) -> (bits: UInt8, data: [UInt8]) {
        guard try kind() == .bitBinary else { throw TermDecodingError.wrongTag }
        _ = try consume()
        let size = try consume(4).withUnsafeBytes {
            UInt32(bigEndian: $0.load(as: UInt32.self))
        }
        return (bits: try consume(), data: try consume(Int(size)))
    }
}