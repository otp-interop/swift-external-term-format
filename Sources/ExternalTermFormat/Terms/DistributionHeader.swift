public extension TermBuffer {
    /// The non-fragmented distribution header format
    mutating func encodeDistributionHeader() {
        append(.distributionHeader) // tag
        append(0) // number of atom cache refs
    }

    mutating func decodeDistributionHeader() throws(TermDecodingError) -> UInt8 {
        guard try kind() == .distributionHeader else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return try consume()
    }
}