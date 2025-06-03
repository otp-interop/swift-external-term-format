public struct PID: Sendable {
    public var node: String
    public var id: UInt32
    public var serial: UInt32
    public var creation: UInt32

    public init(
        node: String,
        id: UInt32,
        serial: UInt32,
        creation: UInt32
    ) {
        self.node = node
        self.id = id
        self.serial = serial
        self.creation = creation
    }
}