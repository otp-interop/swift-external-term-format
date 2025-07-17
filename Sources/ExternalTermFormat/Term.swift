public enum Term: Hashable {
    case distributionHeader(
        flags: [UInt8],
        atomCacheRefs: [UInt8]
    )

    case atomCacheRef(index: UInt8)

    /// Unsigned 8-bit integer.
    case smallInteger(UInt8)
    
    /// Signed 32-bit integer in big-endian format.
    case integer(Int32)

    /// A finite float stored in string format.
    case float(String)

    case port(Port)

    case pid(PID)
    
    indirect case smallTuple([Term])
    indirect case largeTuple([Term])
    
    indirect case map([Term:Term])

    case `nil`

    case string([UInt8])

    indirect case list([Term])

    case binary([UInt8])

    case smallBig(sign: Bool, [UInt8])

    case largeBig(sign: Bool, [UInt8])

    case reference(Reference)

    indirect case fun(arity: UInt8, uniq: [UInt8], index: Int32, module: String, oldIndex: Int, oldUniq: Int, pid: PID, freeVars: [Term])

    case export(module: String, function: String, arity: Int)

    case bitBinary(bits: UInt8, [UInt8])

    case newFloat(Double)

    case atomUTF8(String)

    case smallAtomUTF8(String)
}

public struct PID: Hashable {
    public let node: String
    public let id: UInt32
    public let serial: UInt32
    public let creation: UInt32

    public init(node: String, id: UInt32, serial: UInt32, creation: UInt32) {
        self.node = node
        self.id = id
        self.serial = serial
        self.creation = creation
    }
}

public struct Port: Hashable {
    public let node: String
    public let id: UInt64
    public let creation: UInt32

    public init(node: String, id: UInt64, creation: UInt32) {
        self.node = node
        self.id = id
        self.creation = creation
    }
}

public struct Reference: Hashable {
    public let node: String
    public let creation: UInt32
    public let id: [UInt8]

    public init(node: String, creation: UInt32, id: [UInt8]) {
        self.node = node
        self.creation = creation
        self.id = id
    }
}