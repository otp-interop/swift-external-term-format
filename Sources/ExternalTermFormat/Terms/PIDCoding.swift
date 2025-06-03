public extension TermBuffer {
    /// Encodes a process identifier.
    mutating func encodePID(
        _ pid: PID
    ) {
        append(.pid)
        encodeSmallAtomUTF8(pid.node)
        withUnsafeBytes(of: pid.id.bigEndian) {
            append(contentsOf: $0)
        }
        withUnsafeBytes(of: pid.serial.bigEndian) {
            append(contentsOf: $0)
        }
        withUnsafeBytes(of: pid.creation.bigEndian) {
            append(contentsOf: $0)
        }
    }

    mutating func decodePID() throws(TermDecodingError) -> PID {
        guard try kind() == .pid else { throw TermDecodingError.wrongTag }
        _ = try consume()
        
        let node = try decodeSmallAtomUTF8()
        let id = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
        let serial = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
        let creation = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }

        return PID(
            node: node,
            id: id,
            serial: serial,
            creation: creation
        )
    }
}