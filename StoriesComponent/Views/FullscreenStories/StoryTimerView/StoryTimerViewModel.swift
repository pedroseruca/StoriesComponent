public protocol StoryTimerViewModelProtocol {
    var numberOfStories: Int { get }
    
    func viewDidLoad()
    func didStartLongPress()
    func didEndedLongPress()
    func userSlideToOtherStory() // needs better name
    
    func progressBarViewModel(for index: Int) -> StoryTimerProgressBarViewModelProtocol
    
    func moveForward()
    func moveBackward()
}

class StoryTimerViewModel {
    // MARK: - Private Properties
    
    private var currentStoryIndex = 0
    private let time: Float
    
    private(set) lazy var progressBarsViewModel: [StoryTimerProgressBarViewModelProtocol] =
        (0 ..< numberOfStories).map { _ in
            StoryTimerProgressBarViewModel(animationHasFinishedHandler: animationHasFinished)
        }
    private var currentProgressBar: StoryTimerProgressBarViewModelProtocol { progressBarsViewModel[currentStoryIndex] }
    
    private let animationHasFinishedHandler: AnimationHasFinishHandler

    // MARK: - Public Properties
    
    let numberOfStories: Int

    // MARK: - Lifecycle

    init(numberOfStories: Int, time: Float, animationHasFinishedHandler: @escaping AnimationHasFinishHandler) {
        self.numberOfStories = numberOfStories
        self.time = time
        self.animationHasFinishedHandler = animationHasFinishedHandler
    }
}

// MARK: - Private Methods

private extension StoryTimerViewModel {
    func animationHasFinished(isCompleted: Bool) {
        animationHasFinishedHandler(isCompleted)
    }
}

// MARK: - Protocol Conformance

extension StoryTimerViewModel: StoryTimerViewModelProtocol {
    func progressBarViewModel(for index: Int) -> StoryTimerProgressBarViewModelProtocol {
        progressBarsViewModel[index]
    }
    
    func viewDidLoad() {
        currentProgressBar.reset()
        currentProgressBar.play(for: time)
    }
    
    func didStartLongPress() {
        currentProgressBar.pause()
    }
    
    func didEndedLongPress() {
        currentProgressBar.resume()
    }
    
    func userSlideToOtherStory() {
        currentProgressBar.reset()
    }
    
    func moveForward() {
        currentProgressBar.complete()
        currentStoryIndex += 1
        currentProgressBar.play(for: time)
    }
    
    func moveBackward() {
        currentProgressBar.reset()
        currentStoryIndex -= 1
        currentProgressBar.reset()
        currentProgressBar.play(for: time)
    }
}
