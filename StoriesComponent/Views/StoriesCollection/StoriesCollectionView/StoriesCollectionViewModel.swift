public protocol StoriesCollectionViewModelProtocol {
    var numberOfItems: Int { get }

    func cellViewModelFor(index: Int) -> StoriesGroupCellViewModelProtocol
    func didSelectItemAt(index: Int)

    func bind(presentFullscreenStories: @escaping PresentFullscreenClosure)
}

public typealias PresentFullscreenClosure = (FullscreenViewModelProtocol) -> Void

public class StoriesCollectionViewModel {
    // MARK: - Private Properties

    private let model: StoriesResponse
    private var presentFullscreenStories: PresentFullscreenClosure?

    // MARK: - Public Properties

    public private(set) lazy var numberOfItems = model.stories.count

    // MARK: - Lifecycle

    public init(stories model: StoriesResponse) {
        self.model = model
    }
}

// MARK: - ViewModel Protocol Conformance

extension StoriesCollectionViewModel: StoriesCollectionViewModelProtocol {
    public func cellViewModelFor(index: Int) -> StoriesGroupCellViewModelProtocol {
        StoriesGroupCellViewModel(storiesGroup: model.stories[index])
    }

    public func didSelectItemAt(index: Int) {
        let viewModel = FullscreenViewModel(model: model,
                                            selectedGroup: index)
        presentFullscreenStories?(viewModel)
    }

    public func bind(presentFullscreenStories: @escaping PresentFullscreenClosure) {
        self.presentFullscreenStories = presentFullscreenStories
    }
}
