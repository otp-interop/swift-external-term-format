public extension TermBuffer {
    /// Encodes an EXPORT_EXT term.
    /// | 1     | N1       | N2         | N3      |
    /// | ----- | -------- | ---------- | ------- |
    /// | `113` | `Module` | `Function` | `Arity` |
    mutating func encodeExport(
        module: String,
        function: String,
        arity: UInt8
    ) {
        append(.export)  // 'q'
        encodeSmallAtomUTF8(module)
        encodeSmallAtomUTF8(function)
        encodeSmallInteger(arity)
    }

    mutating func decodeExport() throws(TermDecodingError) -> (module: String, function: String, arity: UInt8) {
        guard try kind() == .export else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return (
            module: try decodeSmallAtomUTF8(),
            function: try decodeSmallAtomUTF8(),
            arity: try decodeSmallInteger(),
        )
    }
}