public protocol ScrollableIndexProtocol: AnyObject {
    var moveForward: () -> Void { get }
    var moveBackward: () -> Void { get }
}

class ScrollableIndexBindings: ScrollableIndexProtocol {
    let moveForward: () -> Void
    let moveBackward: () -> Void
    
    init(_ moveForward: @escaping () -> Void,
         _ moveBackward: @escaping () -> Void) {
        self.moveForward = moveForward
        self.moveBackward = moveBackward
    }
}
