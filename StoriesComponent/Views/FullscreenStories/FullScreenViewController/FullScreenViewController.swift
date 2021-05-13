import UIKit

class FullScreenViewController: UIViewController {
    // MARK: - Subviews

    private lazy var collection: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        
        let collection = UICollectionView(
            frame: view.frame,
            collectionViewLayout: collectionViewLayout
        )
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(FullscreenStoryCell.self)
        return collection
    }()
    
    // MARK: - Private Properties
        
    private var viewModel: FullscreenViewModelProtocol? {
        didSet {
            collection.delegate = self
            collection.dataSource = self
            setInitialIndexOfCollection()
            viewModel?.bind(collectionBindable: collectionBindable,
                            navigationBindable: navigationBindable)
        }
    }
    
    // MARK: - Closures
    
    private lazy var collectionBindable = ScrollableIndexBindings(moveForward, moveBackward)
    private var navigationBindable: ScrollableIndexProtocol

    // MARK: - Lifecycle
    
    init(dismissCallback: @escaping () -> Void ) {
        self.navigationBindable = ScrollableIndexBindings(dismissCallback, {})
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
}

// MARK: - Public Methods

extension FullScreenViewController {
    public func configure(with viewModel: FullscreenViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Methods

private extension FullScreenViewController {
    func moveForward() {
        move(+=)
    }
    
    func moveBackward() {
        move(-=)
    }
    
    func move(_ closure: (_ lhs: inout CGFloat, _ rhs: CGFloat) -> Void) {
        var offset = collection.contentOffset
        closure(&offset.x, collection.frame.width)
        let rect = CGRect(x: offset.x, y: offset.y, width: collection.frame.width, height: collection.frame.height)
        collection.scrollRectToVisible(rect, animated: true)
    }
    
    func setInitialIndexOfCollection() {
        guard let viewModel = viewModel else { return }
        collection.scrollToItem(at: IndexPath(row: viewModel.selectedStoriesGroupIndex, section: 0),
                                at: .centeredHorizontally,
                                animated: false)
        collection.layoutIfNeeded()
        
    }
    
    func setupViews() {
        view.addSubviewAndPin(collection)
    }
}

// MARK: - Collection Delegate

extension FullScreenViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collection.indexPathsForVisibleItems.last else { return }
        viewModel?.scrolledToItemAt(index: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel?.willStartDragging()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        viewModel?.willEndDragging(index: item)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewModel?.cellIsOnScreen()
    }
}

// MARK: - Collection DataSource

extension FullScreenViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FullscreenStoryCell = collection.dequeue(for: indexPath)
        if let viewModel = viewModel?.cellViewModelFor(index: indexPath.row) {
            cell.configure(with: viewModel)
        }
        return cell
    }
}

// MARK: - Collection DelegateFlowLayout

extension FullScreenViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collection.visibleSize.width, height: 835)
    }
}
