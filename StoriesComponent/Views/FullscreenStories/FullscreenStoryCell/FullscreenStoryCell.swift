import UIKit

class FullscreenStoryCell: UICollectionViewCell {
    // MARK: - Subviews

    private lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var storyTimerView = StoryTimerView()

    // MARK: - Private Properties

    private lazy var scrollTapGesture: UITapGestureRecognizer = {
        .init(target: self, action: #selector(didTapOnStory(_:)))
    }()
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        gesture.minimumPressDuration = 0.2
        return gesture
    }()

    private lazy var binds = ScrollableIndexBindings(moveForward, moveBackward)

    private var viewModel: FullscreenStoryCellViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.bind(binds)
            storyTimerView.configure(with: viewModel.storyTimerViewModel)
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = viewModel else { return }
        fillScrollView(model: viewModel.urlList)
        moveToInitialPosition()
    }

    override func prepareForReuse() {
        scrollview.subviews.forEach { $0.removeFromSuperview() }
        super.prepareForReuse()
    }
}

// MARK: - Public Methods

extension FullscreenStoryCell {
    public func configure(with viewModel: FullscreenStoryCellViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Methods

private extension FullscreenStoryCell {
    @objc private func didTapOnStory(_ sender: UITapGestureRecognizer) {
        let touchLocationX = sender.location(ofTouch: 0, in: scrollview).x
        let middleScreen = scrollview.contentOffset.x + (scrollview.frame.width / 2)

        viewModel?.didTapStoryOn(Float(touchLocationX), middleOfScreen: Float(middleScreen))
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            viewModel?.didStartLongPress()
        case .ended:
            viewModel?.didEndedLongPress()
        default:
            return
        }
    }

    func moveForward() {
        move(+=)
    }

    func moveBackward() {
        move(-=)
    }

    func move(_ closure: (_ lhs: inout CGFloat, _ rhs: CGFloat) -> Void) {
        var offset = scrollview.contentOffset
        closure(&offset.x, scrollview.frame.width)
        scrollview.setContentOffset(offset, animated: false)
    }
}

// MARK: - Private Methods - UI configurations

private extension FullscreenStoryCell {
    func fillScrollView(model: [URL]) {
        model.enumerated().forEach(addViewToScrollview)
        scrollview.contentSize = CGSize(width: scrollview.frame.width * CGFloat(model.count), height: scrollview.frame.height)
    }
    
    func moveToInitialPosition() {
        guard let viewModel = viewModel else { return }
        for _ in 0..<viewModel.storyIndex {
            moveForward()
        }
    }

    func addViewToScrollview(_ index: Int, _ url: URL) {
        let width = scrollview.frame.width
        let position = CGFloat(index) * width
        let image = makeImage(startPosition: position)
        image.setImage(from: url)
        scrollview.addSubview(image)
    }

    func makeImage(startPosition: CGFloat) -> UIImageView {
        AspectImageView(frame: CGRect(x: startPosition,
                                      y: .zero,
                                      width: scrollview.frame.width,
                                      height: scrollview.frame.height))
    }

    func setupViews() {
        addSubviewAndPin(scrollview)
        scrollview.addGestureRecognizer(scrollTapGesture)
        scrollview.addGestureRecognizer(longPressGesture)
        addSubview(storyTimerView)
    }

    func setupConstraints() {
        storyTimerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: storyTimerView.leadingAnchor),
            topAnchor.constraint(equalTo: storyTimerView.topAnchor),
            trailingAnchor.constraint(equalTo: storyTimerView.trailingAnchor),
            storyTimerView.heightAnchor.constraint(equalToConstant: 10)]
        )
    }
}
