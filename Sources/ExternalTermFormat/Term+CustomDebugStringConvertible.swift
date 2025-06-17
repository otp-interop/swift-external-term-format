extension Term: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .distributionHeader:
            "<distribution header>"

        case .atomCacheRef:
            "<atom cache ref>"

        case let .smallInteger(integer):
            String(integer)
        
        case let .integer(integer):
            String(integer)

        case let .float(float):
            float

        case let .port(node, id, creation):
            "#Port<\(node.debugDescription), \(id), \(creation)>"
        case let .newPort(node, id, creation):
            "#Port<\(node.debugDescription), \(id), \(creation)>"
        case let .v4Port(node, id, creation):
            "#Port<\(node.debugDescription), \(id), \(creation)>"

        case let .pid(node, id, serial, creation):
            "#PID<\(node.debugDescription), \(id), \(serial), \(creation)>"
        case let .newPID(node, id, serial, creation):
            "#PID<\(node.debugDescription), \(id), \(serial), \(creation)>"
        
        case let .smallTuple(tuple):
            "{\(tuple.map(\.debugDescription).joined(separator: ","))}"
        case let .largeTuple(tuple):
            "{\(tuple.map(\.debugDescription).joined(separator: ","))}"
        
        case let .map(map):
            "%{\(map.map { "\($0.debugDescription) => \($1.debugDescription)" }.joined(separator: ","))}"

        case .nil:
            "nil"

        case let .string(string):
            String(describing: string)

        case let .list(list):
            "[\(list.map(\.debugDescription).joined(separator: ","))]"

        case let .binary(binary):
            "<<\(binary.map(\.description).joined(separator: ","))>>"

        case .smallBig:
            "<small big>"

        case .largeBig:
            "<large big>"

        case let .newReference(node, creation, id):
            "#Reference<\(node.debugDescription), \(creation), \(id)>"
        case let .newerReference(node, creation, id):
            "#Reference<\(node.debugDescription), \(creation), \(id)>"

        case let .newFun(arity, uniq, index, module, oldIndex, oldUniq, pid, freeVars):
            "#Function<\(module.debugDescription)/\(arity)>"

        case let .export(module, function, arity):
            "\(module.debugDescription):\(function.debugDescription)/\(arity)"

        case let .bitBinary(bits, bytes):
            "<<\(bytes.map(\.description).joined(separator: ",")),bits:\(bits)>>"

        case let .newFloat(value):
            String(value)

        case let .atomUTF8(atom):
            #":"\#(atom)""#

        case let .smallAtomUTF8(atom):
            #":"\#(atom)""#
        }
    }
}