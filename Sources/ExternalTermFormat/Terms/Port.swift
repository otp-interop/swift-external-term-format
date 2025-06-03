public extension TermBuffer {
    /// Encodes a port identifier.
    mutating func encodePort(
        node: String,
        id: UInt64,
        creation: UInt32
    ) {
        append(.port)
        encodeSmallAtomUTF8(node)
        withUnsafeBytes(of: id.bigEndian) {
            append(contentsOf: $0)
        }
        withUnsafeBytes(of: creation.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodePort() throws(TermDecodingError) -> (node: String, id: UInt64, creation: UInt32) {
        guard try kind() == .port else { throw TermDecodingError.wrongTag }
        _ = try consume()
        
        let node = try decodeSmallAtomUTF8()
        let id = try consume(8).withUnsafeBytes { UInt64(bigEndian: $0.load(as: UInt64.self)) }
        let creation = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }

        return (node: node, id: id, creation: creation)
    }
}