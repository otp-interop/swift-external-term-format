import BinaryParsing

extension Term: ExpressibleByParsing {
    @inlinable @inline(__always)
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
                    ) { (input: inout ParserSpan) -> UInt8 in
                        guard try UInt8(parsing: &input) == 82 // atom cache ref
                        else { fatalError() }
                        return try UInt8(parsing: &input)
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
        
        case 120: // v4 port
            self = .port(Port(
                node: try Term.atom(parsing: &input),
                id: try UInt64(parsingBigEndian: &input),
                creation: try UInt32(parsingBigEndian: &input)
            ))
        
        case 88: // new pid
            self = .pid(PID(
                node: try Term.atom(parsing: &input),
                id: try UInt32(parsingBigEndian: &input),
                serial: try UInt32(parsingBigEndian: &input),
                creation: try UInt32(parsingBigEndian: &input)
            ))
        
        case 104: // small tuple
            let arity = Int(try UInt8(parsing: &input))
            self = .smallTuple(try Array<Term>(unsafeUninitializedCapacity: arity) { buffer, initializedCount in
                for i in 0..<arity {
                    buffer[i] = try Term(parsing: &input)
                }
                initializedCount = arity
            })
        case 105: // large tuple
            let arity = Int(try UInt32(parsingBigEndian: &input))
            self = .largeTuple(try Array<Term>(unsafeUninitializedCapacity: arity) { buffer, initializedCount in
                for i in 0..<arity {
                    buffer[i] = try Term(parsing: &input)
                }
                initializedCount = arity
            })
        
        case 116: // map
            let arity = try UInt32(parsingBigEndian: &input)
            var map = [Term:Term]()
            map.reserveCapacity(Int(arity))
            for _ in 0..<arity {
                let key = try Term(parsing: &input)
                let value = try Term(parsing: &input)
                map[key] = value
            }
            self = .map(map)

        case 106: // nil
            self = .nil

        case 107: // string
            let length = try UInt16(parsingBigEndian: &input)
            self = .string(try [UInt8](parsing: &input, byteCount: Int(length)))
        case 108: // list
            let length = Int(try UInt32(parsingBigEndian: &input))
            self = .list(try Array<Term>(unsafeUninitializedCapacity: length + 1) { buffer, initializedCount in
                for i in 0...length {
                    buffer[i] = try Term(parsing: &input)
                }
                initializedCount = length
            })
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

        case 90: // newer reference
            let length = try UInt16(parsingBigEndian: &input)
            self = .reference(Reference(
                node: try Term.atom(parsing: &input),
                creation: try UInt32(parsingBigEndian: &input),
                id: try [UInt8](parsing: &input, byteCount: Int(length))
            ))

        case 112: // new fun
            _ = try UInt32(parsingBigEndian: &input) // size
            let arity = try UInt8(parsing: &input)
            let uniq = try [UInt8](parsing: &input, byteCount: 16)
            let index = try Int32(parsingBigEndian: &input)
            let numFree = try UInt32(parsingBigEndian: &input)
            let module = try Term.atom(parsing: &input)
            let oldIndex = try Term.integer(parsing: &input)
            let oldUniq = try Term.integer(parsing: &input)
            let pid = try PID(parsing: &input)
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
                module: try Term.atom(parsing: &input),
                function: try Term.atom(parsing: &input),
                arity: try Term.integer(parsing: &input)
            )

        case 77: // bit binary
            let length = try UInt32(parsingBigEndian: &input)
            self = .bitBinary(
                bits: try UInt8(parsing: &input),
                try [UInt8](parsing: &input, byteCount: Int(length))
            )

        case 70: // new float
            self = .newFloat(Double(bitPattern: try UInt64(parsingBigEndian: &input)))

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

    @inline(__always)
    @usableFromInline
    static func atom(parsing input: inout ParserSpan) throws(ThrownParsingError) -> String {
        switch try UInt8(parsing: &input) {
        case 118: // atom utf8
            let length = try UInt16(parsingBigEndian: &input)
            return try String(parsingUTF8: &input, count: Int(length))
        case 119: // small atom utf8
            let length = try UInt8(parsing: &input)
            return try String(parsingUTF8: &input, count: Int(length))
        default:
            fatalError()
        }
    }    

    @inline(__always)
    @usableFromInline
    static func integer(parsing input: inout ParserSpan) throws(ThrownParsingError) -> Int {
        switch try UInt8(parsing: &input) {
        case 97: // small integer
            return Int(try UInt8(parsing: &input))
        case 98: // integer
            return Int(try Int32(parsingBigEndian: &input))
        default:
            fatalError()
        }
    }
}

extension PID: ExpressibleByParsing {
    @inlinable @inline(__always)
    public init(parsing input: inout ParserSpan) throws(ThrownParsingError) {
        guard try UInt8(parsing: &input) == 88
        else { fatalError() }
        self.node = try Term.atom(parsing: &input)
        self.id = try UInt32(parsingBigEndian: &input)
        self.serial = try UInt32(parsingBigEndian: &input)
        self.creation = try UInt32(parsingBigEndian: &input)
    }
}