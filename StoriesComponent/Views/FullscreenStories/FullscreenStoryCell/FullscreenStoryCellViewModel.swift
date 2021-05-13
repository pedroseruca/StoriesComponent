import Foundation

public protocol FullscreenStoryCellViewModelProtocol {
    var urlList: [URL] { get }
    var storyIndex: Int { get }
    
    func didTapStoryOn(_ touchLocation: Float, middleOfScreen: Float)
    func bind(_ bindable: ScrollableIndexProtocol)
    
    var storyTimerViewModel: StoryTimerViewModelProtocol { get }
    func viewDidLoad()
    func viewDidDisappear()
    func didStartLongPress()
    func didEndedLongPress()
}

class FullscreenStoryCellViewModel {
    // MARK: - Private Properties
    
    private let model: StoriesGroup
    
    @ScrollableIndex
    private(set) var storyIndex: Int = 0
    
    private weak var scrollViewBindable: ScrollableIndexProtocol?
    private weak var collectionBindable: ScrollableIndexProtocol?

    // MARK: - Public Properties

    private(set) lazy var urlList = model.list
        .map(\.imageUrl)
        .compactMap { $0 }
    
    private(set) lazy var storyTimerViewModel: StoryTimerViewModelProtocol = StoryTimerViewModel(
        numberOfStories: urlList.count,
        // this time should be taken from the model
        time: 5,
        // does this make a retain cycle?
        animationHasFinishedHandler: moveForward
    )

    // MARK: - Lifecycle

    init(storiesGroup model: StoriesGroup,
         bindable: ScrollableIndexProtocol) {
        self.model = model
        self.collectionBindable = bindable
    }
}

// MARK: - Private Methods

private extension FullscreenStoryCellViewModel {
    func configureScrollableIndex() {
        _storyIndex.maxRange = urlList.count - 1
        _storyIndex.backwards = {
            self.scrollViewBindable?.moveBackward()
            self.storyTimerViewModel.moveBackward()
        }
        _storyIndex.forward = {
            self.scrollViewBindable?.moveForward()
            self.storyTimerViewModel.moveForward()
        }
        _storyIndex.outOfBoundsBackwards = {
            self.viewDidDisappear()
            self.collectionBindable?.moveBackward()
            
        }
        _storyIndex.outOfBoundsForward = {
            self.viewDidDisappear()
            self.collectionBindable?.moveForward()
        }
    }
    
    func moveForward(isCompleted: Bool) {
        if isCompleted {
            storyIndex += 1
        }
    }
}

// MARK: - ViewModel Protocol Conformance

extension FullscreenStoryCellViewModel: FullscreenStoryCellViewModelProtocol {
    func bind(_ bindable: ScrollableIndexProtocol) {
        scrollViewBindable = bindable
        configureScrollableIndex()
    }

    func didTapStoryOn(_ touchLocation: Float, middleOfScreen: Float) {
        let nextIndexChange = touchLocation > middleOfScreen ? 1 : -1
        storyIndex += nextIndexChange
    }
    
    func didStartLongPress() {
        storyTimerViewModel.didStartLongPress()
    }
    
    func didEndedLongPress() {
        storyTimerViewModel.didEndedLongPress()
    }
    
    func viewDidLoad() {
        storyTimerViewModel.viewDidLoad()
    }
    
    func viewDidDisappear() {
        storyTimerViewModel.userSlideToOtherStory()
    }
}
