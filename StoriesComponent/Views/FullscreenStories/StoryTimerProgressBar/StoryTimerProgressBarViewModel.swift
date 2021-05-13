import Foundation

public protocol StoryTimerProgressBarViewModelProtocol: AnyObject {
    func bind(_ bindings: StoryTimerBindings)
    func pause()
    func resume()
    func reset()
    func play(for seconds: Float)
    func complete()
    
    var hasCompleted: Bool { get }
    func animationHasFinished(isCompleted: Bool)
}

final class StoryTimerProgressBarViewModel {
    // MARK: - Private Properties
    
    private weak var bindings: StoryTimerBindings?
    private let animationHasFinishedHandler: AnimationHasFinishHandler

    // MARK: - Public Properties
    
    private(set) var hasCompleted: Bool = false

    // MARK: - Lifecycle

    init(animationHasFinishedHandler: @escaping AnimationHasFinishHandler) {
        self.animationHasFinishedHandler = animationHasFinishedHandler
    }
}

// MARK: - Private Methods

private extension StoryTimerProgressBarViewModel {
    
}

// MARK: - Protocol Conformance

extension StoryTimerProgressBarViewModel: StoryTimerProgressBarViewModelProtocol {
    func bind(_ bindings: StoryTimerBindings) {
        self.bindings = bindings
    }
    
    func pause() {
        bindings?.pause()
    }
    
    func resume() {
        bindings?.resume()
    }
    
    func reset() {
        hasCompleted = false
        bindings?.reset()
    }
    
    func play(for seconds: Float) {
        bindings?.start(TimeInterval(seconds))
    }
    
    func complete() {
        hasCompleted = true
        bindings?.complete()
    }
    
    func animationHasFinished(isCompleted: Bool) {
        animationHasFinishedHandler(isCompleted)
    }
}
