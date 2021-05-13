
import Foundation

public protocol StoriesGroupCellViewModelProtocol {
    var name: String { get }
    var imageURL: URL? { get }
}

public class StoriesGroupCellViewModel: StoriesGroupCellViewModelProtocol {
    // MARK: - Private Properties

    private let model: StoriesGroup

    // MARK: - Public Properties

    public private(set) lazy var name = model.name
    public private(set) lazy var imageURL = model.imageUrl

    // MARK: - Lifecycle

    public init(storiesGroup model: StoriesGroup) {
        self.model = model
    }
}
