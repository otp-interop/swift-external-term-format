public extension TermBuffer {
    /// An atom length and string encoded as UTF-8.
    mutating func encodeSmallAtomUTF8(_ value: String) {
        append(.smallAtomUTF8)
        append(UInt8(value.utf8.count))
        append(contentsOf: value.utf8)
    }

    mutating func decodeSmallAtomUTF8() throws(TermDecodingError) -> String {
        guard try kind() == .smallAtomUTF8 else { throw TermDecodingError.wrongTag }
        _ = try consume()

        let count = Int(try consume())
        let atom = String(decoding: try consume(count), as: UTF8.self)

        return atom
    }
}