public extension TermBuffer {
    /// Encodes a reference.
    mutating func encodeReference(
        node: String,
        creation: UInt32,
        id: [UInt32]
    ) {
        append(.reference)
        withUnsafeBytes(of: UInt16(id.count).bigEndian) {
            append(contentsOf: $0)
        }
        encodeSmallAtomUTF8(node)
        withUnsafeBytes(of: creation) {
            append(contentsOf: $0)
        }
        for element in id {
            withUnsafeBytes(of: element.bigEndian) {
                append(contentsOf: $0)
            }
        }
    }

    mutating func decodeReference() throws(TermDecodingError) -> (node: String, creation: UInt32, id: [UInt32]) {
        guard try kind() == .reference else { throw TermDecodingError.wrongTag }
        _ = try consume()

        let idCount = try consume(2).withUnsafeBytes { UInt16(bigEndian: $0.load(as: UInt16.self)) }
        
        let node = try decodeSmallAtomUTF8()
        
        let creation = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }

        let id = (0..<idCount).compactMap { _ in try? consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) } }
        guard id.count == idCount else { throw TermDecodingError.decodingError }

        return (node: node, creation: creation, id: id)
    }
}