@propertyWrapper
struct ScrollableIndex {
    // MARK: - Bindings

    var forward: (() -> Void)?
    var backwards: (() -> Void)?

    var outOfBoundsForward: (() -> Void)?
    var outOfBoundsBackwards: (() -> Void)?

    // MARK: - Private Properties

    private var value: Int

    // MARK: - Public Properties

    var maxRange: Int = 0

    var wrappedValue: Int {
        get { value }
        set {
            if newValue > value {
                if newValue > maxRange {
                    outOfBoundsForward?()
                    return
                }
                value = newValue
                forward?()
                return
            }
            if newValue < value {
                if newValue < 0 {
                    outOfBoundsBackwards?()
                    return
                }
                value = newValue
                backwards?()
                return
            }
        }
    }

    // MARK: Lifecycle

    init(wrappedValue value: Int) {
        self.value = value
    }
}
