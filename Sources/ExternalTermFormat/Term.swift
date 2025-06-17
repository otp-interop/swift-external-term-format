public indirect enum Term: Hashable {
    case distributionHeader(
        flags: [UInt8],
        atomCacheRefs: [Term]
    )

    case atomCacheRef(index: UInt8)

    /// Unsigned 8-bit integer.
    case smallInteger(UInt8)
    
    /// Signed 32-bit integer in big-endian format.
    case integer(Int32)

    /// A finite float stored in string format.
    case float(String)

    case port(node: Term, id: UInt32, creation: UInt8)
    case newPort(node: Term, id: UInt32, creation: UInt32)
    case v4Port(node: Term, id: UInt64, creation: UInt32)

    case pid(node: Term, id: UInt32, serial: UInt32, creation: UInt8)
    case newPID(node: Term, id: UInt32, serial: UInt32, creation: UInt32)
    
    case smallTuple([Term])
    case largeTuple([Term])
    
    case map([Term])

    public struct MapPair: Hashable {
        public let key: Term
        public let value: Term

        public init(key: Term, value: Term) {
            self.key = key
            self.value = value
        }
    }

    case `nil`

    case string([UInt8])

    case list([Term])

    case binary([UInt8])

    case smallBig(sign: Bool, [UInt8])

    case largeBig(sign: Bool, [UInt8])

    case newReference(node: Term, creation: UInt8, id: [UInt8])
    case newerReference(node: Term, creation: UInt32, id: [UInt8])

    case newFun(arity: UInt8, uniq: [UInt8], index: Int32, module: Term, oldIndex: Term, oldUniq: Term, pid: Term, freeVars: [Term])

    case export(module: Term, function: Term, arity: Term)

    case bitBinary(bits: UInt8, [UInt8])

    case newFloat([UInt8])

    case atomUTF8(String)

    case smallAtomUTF8(String)
}