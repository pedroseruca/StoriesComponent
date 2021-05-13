import UIKit

final class StoryTimerView: UIView {
    private let spaceBetweenTimers: CGFloat = 8

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = spaceBetweenTimers
        view.distribution = .fillEqually
        return view
    }()

    private var stackViewSubviews: [StoryTimerProgressBar] = []
    
    private var viewModel: StoryTimerViewModelProtocol? {
        didSet {
            resetProgressBars()
        }
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension StoryTimerView {
    public func configure(with viewModel: StoryTimerViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Methods

private extension StoryTimerView {
    func setupViews() {
        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -spaceBetweenTimers),
            topAnchor.constraint(equalTo: stackView.topAnchor, constant: -7),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: spaceBetweenTimers),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)]
        )
    }

    func fillStackView(with storyCount: Int) {
        guard let viewModel = viewModel else { return }
        for index in 0 ..< storyCount {
            let progressBarViewModel = viewModel.progressBarViewModel(for: index)
            let view = StoryTimerProgressBar(with: progressBarViewModel)
            stackViewSubviews.append(view)
            stackView.addArrangedSubview(view)
        }
    }
    
    func resetStackView() {
        stackViewSubviews = []
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func resetProgressBars() {
        resetStackView()
        fillStackView(with: viewModel?.numberOfStories ?? 0)
    }
}
