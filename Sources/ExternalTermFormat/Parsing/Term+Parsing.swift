import BinaryParsing

extension Term: ExpressibleByParsing {
    @_alwaysEmitIntoClient
    @inlinable
    public init(parsing input: inout ParserSpan) throws(ThrownParsingError) {
        switch try UInt8(parsing: &input) {
        case 131: // version header
            self = try Term(parsing: &input)
        case 68: // distribution header
            let numberOfAtomCacheRefs = try UInt8(parsing: &input)
            if numberOfAtomCacheRefs > 0 {
                self = .distributionHeader(
                    flags: try [UInt8](parsing: &input, byteCount: Int(numberOfAtomCacheRefs / 2 + 1)),
                    atomCacheRefs: try Array(
                        parsing: &input,
                        count: Int(numberOfAtomCacheRefs)
                    ) { (span: inout ParserSpan) -> Term in
                        try Term(parsing: &span)
                    }
                )
            } else {
                self = .distributionHeader(flags: [], atomCacheRefs: [])
            }
        case 82: // atom cache ref
            self = .atomCacheRef(index: try UInt8(parsing: &input))
        case 97: // small integer
            self = .smallInteger(try UInt8(parsing: &input))
        case 98: // integer
            self = .integer(try Int32(parsingBigEndian: &input))
        case 99: // float
            self = .float(try String(parsingUTF8: &input, count: 31))
        
        case 102: // port
            self = .port(
                node: try Term(parsing: &input),
                id: try UInt32(parsingBigEndian: &input),
                creation: try UInt8(parsing: &input)
            )
        case 89: // new port
            self = .newPort(
                node: try Term(parsing: &input),
                id: try UInt32(parsingBigEndian: &input),
                creation: try UInt32(parsingBigEndian: &input)
            )
        case 120: // v4 port
            self = .v4Port(
                node: try Term(parsing: &input),
                id: try UInt64(parsingBigEndian: &input),
                creation: try UInt32(parsingBigEndian: &input)
            )
        
        case 103: // pid
            self = .pid(
                node: try Term(parsing: &input),
                id: try UInt32(parsingBigEndian: &input),
                serial: try UInt32(parsingBigEndian: &input),
                creation: try UInt8(parsing: &input)
            )
        case 88: // new pid
            self = .newPID(
                node: try Term(parsing: &input),
                id: try UInt32(parsingBigEndian: &input),
                serial: try UInt32(parsingBigEndian: &input),
                creation: try UInt32(parsingBigEndian: &input)
            )
        
        case 104: // small tuple
            let arity = try UInt8(parsing: &input)
            var tuple = [Term]()
            tuple.reserveCapacity(Int(arity))
            for _ in 0..<arity {
                tuple.append(try Term(parsing: &input))
            }
            self = .smallTuple(tuple)
        case 105: // large tuple
            let arity = try UInt32(parsingBigEndian: &input)
            var tuple = [Term]()
            tuple.reserveCapacity(Int(arity))
            for _ in 0..<arity {
                tuple.append(try Term(parsing: &input))
            }
            self = .largeTuple(tuple)
        
        case 116: // map
            let arity = try UInt32(parsingBigEndian: &input)
            var map = [Term]()
            map.reserveCapacity(Int(arity))
            for _ in 0..<arity {
                map.append(try Term(parsing: &input))
                map.append(try Term(parsing: &input))
            }
            self = .map(map)

        case 106: // nil
            self = .nil

        case 107: // string
            let length = try UInt16(parsingBigEndian: &input)
            self = .string(try [UInt8](parsing: &input, byteCount: Int(length)))
        case 108: // list
            let length = try UInt32(parsingBigEndian: &input)
            var list = [Term]()
            list.reserveCapacity(Int(length))
            for _ in 0..<length {
                list.append(try Term(parsing: &input))
            }
            self = .list(list)
        case 109: // binary
            let length = try UInt32(parsingBigEndian: &input)
            self = .binary(try [UInt8](parsing: &input, byteCount: Int(length)))

        case 110: // small big
            let n = try UInt8(parsing: &input)
            self = .smallBig(
                sign: try UInt8(parsing: &input) == 1,
                try [UInt8](parsing: &input, byteCount: Int(n))
            )
        case 111: // large big
            let n = try UInt32(parsingBigEndian: &input)
            self = .largeBig(
                sign: try UInt8(parsing: &input) == 1,
                try [UInt8](parsing: &input, byteCount: Int(n))
            )

        case 114: // new reference
            let length = try UInt16(parsingBigEndian: &input)
            self = .newReference(
                node: try Term(parsing: &input),
                creation: try UInt8(parsing: &input),
                id: try [UInt8](parsing: &input, byteCount: Int(length))
            )
        case 90: // newer reference
            let length = try UInt16(parsingBigEndian: &input)
            self = .newerReference(
                node: try Term(parsing: &input),
                creation: try UInt32(parsingBigEndian: &input),
                id: try [UInt8](parsing: &input, byteCount: Int(length))
            )

        case 112: // new fun
            _ = try UInt32(parsingBigEndian: &input) // size
            let arity = try UInt8(parsing: &input)
            let uniq = try [UInt8](parsing: &input, byteCount: 16)
            let index = try Int32(parsingBigEndian: &input)
            let numFree = try UInt32(parsingBigEndian: &input)
            let module = try Term(parsing: &input)
            let oldIndex = try Term(parsing: &input)
            let oldUniq = try Term(parsing: &input)
            let pid = try Term(parsing: &input)
            let freeVars = try [Term](parsing: &input, count: Int(numFree)) {
                try Term(parsing: &$0)
            }
            self = .newFun(
                arity: arity,
                uniq: uniq,
                index: index,
                module: module,
                oldIndex: oldIndex,
                oldUniq: oldUniq,
                pid: pid,
                freeVars: freeVars
            )

        case 113: // export
            self = .export(
                module: try Term(parsing: &input),
                function: try Term(parsing: &input),
                arity: try Term(parsing: &input)
            )

        case 77: // bit binary
            let length = try UInt32(parsingBigEndian: &input)
            self = .bitBinary(
                bits: try UInt8(parsing: &input),
                try [UInt8](parsing: &input, byteCount: Int(length))
            )

        case 70: // new float
            self = .newFloat(try [UInt8](parsing: &input, byteCount: 8))

        case 118: // atom utf8
            let length = try UInt16(parsingBigEndian: &input)
            self = .atomUTF8(try String(parsingUTF8: &input, count: Int(length)))

        case 119: // small atom utf8
            let length = try UInt8(parsing: &input)
            self = .smallAtomUTF8(try String(parsingUTF8: &input, count: Int(length)))

        default:
            fatalError()
        }
    }
}