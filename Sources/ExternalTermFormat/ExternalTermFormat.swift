public struct TermBuffer {
    public private(set) var buffer: [UInt8] = []

    public var index: Int = 0

    public init() {}

    public init(_ buffer: [UInt8]) {
        self.buffer = buffer
    }

    public mutating func encodeVersion() {
        append(131)
    }

    public mutating func decodeVersion() throws(TermDecodingError) -> UInt8 {
        guard try peek() == 131
        else { throw TermDecodingError.wrongTag }
        _ = try consume()
        return 131
    }

    mutating func append(_ tag: TermKind) {
        append(tag.rawValue)
    }

    mutating func append(_ value: UInt8) {
        if self.buffer.isEmpty {
            self.buffer.append(value)
        } else {
            self.buffer.insert(value, at: index + 1)
            index += 1
        }
    }

    public mutating func append(contentsOf other: some Sequence<UInt8>) {
        for byte in other {
            append(byte)
        }
    }

    mutating func insert(contentsOf other: some Collection<UInt8>, at index: Int) {
        buffer.insert(contentsOf: other, at: index)
    }
}

extension TermBuffer {
    func peek(_ count: Int) throws(TermDecodingError) -> [UInt8] {
        guard buffer.indices.contains(index + count)
        else { throw TermDecodingError.outOfBounds }
        return Array(buffer[index...(index + count)])
    }

    mutating func consume(_ count: Int) throws(TermDecodingError) -> [UInt8] {
        guard buffer.indices.contains(index + count - 1)
        else { throw TermDecodingError.outOfBounds }
        defer { index += count }
        return Array(buffer[index..<(index + count)])
    }

    func peek() throws(TermDecodingError) -> UInt8 {
        guard buffer.indices.contains(index)
        else { throw TermDecodingError.outOfBounds }
        return buffer[index]
    }

    mutating func consume() throws(TermDecodingError) -> UInt8 {
        guard buffer.indices.contains(index)
        else { throw TermDecodingError.outOfBounds }
        defer { index += 1 }
        return buffer[index]
    }
}

extension TermBuffer {
    public func kind() throws(TermDecodingError) -> TermKind {
        guard let kind = TermKind(rawValue: try peek())
        else { throw TermDecodingError.wrongTag }
        return kind
    }

    public mutating func skip() throws(TermDecodingError) {
        let kind = try kind()
        switch kind {
        case .version:
            _ = try decodeVersion()
        case .binary:
            _ = try decodeBinary()
        case .bitBinary:
            _ = try decodeBitBinary()
        case .distributionHeader:
            _ = try decodeDistributionHeader()
        case .export:
            _ = try decodeExport()
        case .float:
            _ = try decodeFloat()
        case .function:
            _ = try decodeFunction()
        case .integer:
            _ = try decodeInteger()
        case .largeBig:
            _ = try decodeLargeBig()
        case .largeTuple:
            let size = try decodeLargeTupleHeader()
            for _ in 0..<size {
                try skip()
            }
        case .list:
            let size = try decodeListHeader()
            for _ in 0..<size {
                try skip()
            }
        case .map:
            let size = try decodeMapHeader()
            for _ in 0..<size {
                try skip() // key
                try skip() // value
            }
        case .nil:
            try decodeNil()
        case .pid:
            _ = try decodePID()
        case .port:
            _  = try decodePort()
        case .reference:
            _ = try decodeReference()
        case .smallAtomUTF8:
            _ = try decodeSmallAtomUTF8()
        case .smallBig:
            _ = try decodeSmallBig()
        case .smallInteger:
            _ = try decodeSmallInteger()
        case .smallTuple:
            let size = try decodeSmallTupleHeader()
            for _ in 0..<size {
                try skip()
            }
        case .string:
            _ = try decodeString()
        }
    }
}

public enum TermKind: UInt8, Hashable {
    case distributionHeader = 68
    case float               = 70
    case bitBinary          = 77
    case pid                = 88
    case reference          = 90
    case smallInteger       = 97
    case integer            = 98
    case smallTuple         = 104
    case largeTuple         = 105
    case `nil`              = 106
    case string             = 107
    case list               = 108
    case binary             = 109
    case smallBig           = 110
    case largeBig           = 111
    case function           = 112
    case export             = 113
    case map                = 116
    case smallAtomUTF8      = 119
    case port               = 120
    case version            = 131
}

public enum TermDecodingError: Error {
    case missing
    case wrongTag
    case decodingError
    case outOfBounds
}