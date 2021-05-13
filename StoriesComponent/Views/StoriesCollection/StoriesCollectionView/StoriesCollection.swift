import UIKit

public class StoriesCollection: UIView {
    // MARK: - Subviews

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(StoriesGroupCell.self)
        return collection
    }()

    // MARK: - Private Properties

    private var viewModel: StoriesCollectionViewModelProtocol? {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            viewModel?.bind(presentFullscreenStories: presentFullscreenStories)
        }
    }

    private let navigationController: UINavigationController

    // MARK: - Lifecycle

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        navigationController = UINavigationController()
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension StoriesCollection {
    public func configure(with viewModel: StoriesCollectionViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Methods

private extension StoriesCollection {
    private func setupViews() {
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            topAnchor.constraint(equalTo: collectionView.topAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionHeight)]
        )
    }

    private func presentFullscreenStories(_ viewModel: FullscreenViewModelProtocol) {
        let fullscreenViewController = FullScreenViewController(dismissCallback: dismissFullscreenViewController)
        navigationController.present(fullscreenViewController, animated: true)
        fullscreenViewController.configure(with: viewModel)
    }
    
    private func dismissFullscreenViewController() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - Collection Delegate

extension StoriesCollection: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItemAt(index: indexPath.row)
    }
}

// MARK: - Collection DataSource

extension StoriesCollection: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoriesGroupCell = collectionView.dequeue(for: indexPath)
        if let viewModel = viewModel?.cellViewModelFor(index: indexPath.row) {
            cell.configure(with: viewModel)
        }
        return cell
    }
}

// MARK: - Collection DelegateFlowLayout

extension StoriesCollection: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.collectionCellSize
    }
}
