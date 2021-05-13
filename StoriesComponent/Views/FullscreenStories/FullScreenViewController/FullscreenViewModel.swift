
public protocol FullscreenViewModelProtocol {
    var numberOfItems: Int { get }
    var selectedStoriesGroupIndex: Int { get }

    func willStartDragging()
    func willEndDragging(index: Int)
    
    
    func cellViewModelFor(index: Int) -> FullscreenStoryCellViewModelProtocol
    func cellIsOnScreen()
    func didSelectItemAt(index: Int)
    func scrolledToItemAt(index: Int)
    
    func bind(collectionBindable: ScrollableIndexProtocol,
              navigationBindable: ScrollableIndexProtocol)
}

class FullscreenViewModel {
    // MARK: - Private Properties

    private let model: StoriesResponse

    private lazy var binds = ScrollableIndexBindings(moveForward, moveBackward)
    private weak var collectionBindable: ScrollableIndexProtocol?
    private weak var navigationBindable: ScrollableIndexProtocol?
    
    private var willEndDraggingIndex: Int?

    // MARK: - Public Properties

    private(set) lazy var numberOfItems = model.stories.count
    
    private lazy var cellViewModel: [FullscreenStoryCellViewModelProtocol] = model
        .stories
        .map(makeCellViewModel(_:))

    @ScrollableIndex
    private(set) var selectedStoriesGroupIndex: Int

    // MARK: - Lifecycle

    init(model: StoriesResponse,
         selectedGroup selectedStoriesGroupIndex: Int) {
        self.model = model
        self.selectedStoriesGroupIndex = selectedStoriesGroupIndex
    }
}

// MARK: - Private Methods

private extension FullscreenViewModel {
    func configureScrollableIndex() {
        _selectedStoriesGroupIndex.maxRange = numberOfItems - 1
        addScrollableIndexBinds()
    }
    
    func moveForward() {
        selectedStoriesGroupIndex += 1
    }

    func moveBackward() {
        selectedStoriesGroupIndex -= 1
    }
    
    func removeScrollableIndexBinds() {
        _selectedStoriesGroupIndex.forward = nil
        _selectedStoriesGroupIndex.backwards = nil
        _selectedStoriesGroupIndex.outOfBoundsForward = nil
    }
    
    func addScrollableIndexBinds() {
        _selectedStoriesGroupIndex.forward = collectionBindable?.moveForward
        _selectedStoriesGroupIndex.backwards = collectionBindable?.moveBackward
        _selectedStoriesGroupIndex.outOfBoundsForward = navigationBindable?.moveForward
    }
    
    func makeCellViewModel(_ storyGroup: StoriesGroup) -> FullscreenStoryCellViewModel {
        .init(storiesGroup: storyGroup,
              bindable: binds)
    }
}

// MARK: - ViewModel Protocol Conformance

extension FullscreenViewModel: FullscreenViewModelProtocol {
    func bind(collectionBindable: ScrollableIndexProtocol,
              navigationBindable: ScrollableIndexProtocol) {
        self.collectionBindable = collectionBindable
        self.navigationBindable = navigationBindable
        configureScrollableIndex()
    }
    
    func willStartDragging() {
        cellViewModelFor(index: selectedStoriesGroupIndex).didStartLongPress()
    }
    
    func willEndDragging(index: Int) {
        willEndDraggingIndex = index
    }
    
    func cellViewModelFor(index: Int) -> FullscreenStoryCellViewModelProtocol {
        cellViewModel[index]
    }

    func didSelectItemAt(index: Int) {}
    
    func scrolledToItemAt(index: Int) {
        let index = willEndDraggingIndex ?? index
        willEndDraggingIndex = nil
        let currentIndex = selectedStoriesGroupIndex
        if currentIndex == index {
            cellViewModelFor(index: selectedStoriesGroupIndex).didEndedLongPress()
        } else {
            removeScrollableIndexBinds()
            selectedStoriesGroupIndex = index
            addScrollableIndexBinds()
            cellViewModelFor(index: currentIndex).viewDidDisappear()
            cellIsOnScreen()
        }
    }
    
    func cellIsOnScreen() {
        cellViewModelFor(index: selectedStoriesGroupIndex).viewDidLoad()
    }
}
