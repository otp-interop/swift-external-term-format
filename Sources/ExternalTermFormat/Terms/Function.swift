public extension TermBuffer {
    /// Encodes a NEW_FUN_EXT term.
    /// | 1     | 4      | 1       | 16     | 4       | 4         | N1       | N2         | N3        | N4    | N5          |
    /// | ----- | ------ | ------- | ------ | ------- | --------- | -------- | ---------- | --------- | ----- | ----------- |
    /// | `112` | `Size` | `Arity` | `Uniq` | `Index` | `NumFree` | `Module` | `OldIndex` | `OldUniq` | `Pid` | `Free Vars` |
    mutating func encodeFunction(
        arity: UInt8,
        uniq: [UInt8],
        index: UInt32,
        module: String,
        oldIndex: Int,
        oldUniq: Int,
        pid: PID,
        freeVars: [[UInt8]]
    ) {
        append(.function)  // 'p'
        
        let startIndex = self.index
        
        append(arity)
        append(contentsOf: uniq.prefix(16))  // MD5 hash is 16 bytes
        
        withUnsafeBytes(of: index.bigEndian) {
            append(contentsOf: $0)
        }
        
        let numFree = UInt32(freeVars.count)
        withUnsafeBytes(of: numFree.bigEndian) {
            append(contentsOf: $0)
        }
        
        encodeSmallAtomUTF8(module)
        
        // Encode oldIndex as SMALL_INTEGER_EXT or INTEGER_EXT
        if (0...255).contains(oldIndex) {
            encodeSmallInteger(UInt8(oldIndex))
        } else {
            encodeInteger(Int32(oldIndex))
        }
        
        // Encode oldUniq as SMALL_INTEGER_EXT or INTEGER_EXT
        if (0...255).contains(oldUniq) {
            encodeSmallInteger(UInt8(oldUniq))
        } else {
            encodeInteger(Int32(oldUniq))
        }
        
        encodePID(pid)
        
        // Encode free variables
        for freeVar in freeVars {
            append(contentsOf: freeVar)
        }
        
        // Calculate and write the size
        let size = UInt32(self.index - startIndex)
        withUnsafeBytes(of: size.bigEndian) { bytes in
            insert(contentsOf: bytes, at: startIndex + 1)
        }
    }

    mutating func decodeFunction() throws(TermDecodingError) -> (
        arity: UInt8,
        uniq: [UInt8],
        index: UInt32,
        module: String,
        oldIndex: Int,
        oldUniq: Int,
        pid: PID,
        numFree: UInt32,
        freeVars: [UInt8]
    ) {
        guard try kind() == .function else { throw TermDecodingError.wrongTag }
        _ = try consume()

        let startIndex = index

        let size = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
        
        let arity = try consume()

        let uniq = try consume(16)

        let index = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }

        // numFree
        let numFree = try consume(4).withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }

        let module = try decodeSmallAtomUTF8()

        let oldIndex = (try? Int(decodeSmallInteger())) ?? (try? Int(decodeInteger()))
        guard let oldIndex else { throw TermDecodingError.decodingError }
        
        let oldUniq = (try? Int(decodeSmallInteger())) ?? (try? Int(decodeInteger()))
        guard let oldUniq else { throw TermDecodingError.decodingError }
        
        let pid = try decodePID()

        let freeVars = try consume((startIndex + Int(size)) - self.index)

        return (
            arity: arity,
            uniq: Array(uniq),
            index: index,
            module: module,
            oldIndex: oldIndex,
            oldUniq: oldUniq,
            pid: pid,
            numFree: numFree,
            freeVars: freeVars
        )
    }
}