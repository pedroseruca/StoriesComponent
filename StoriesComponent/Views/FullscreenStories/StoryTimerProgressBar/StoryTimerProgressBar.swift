import UIKit

typealias AnimationHasFinishHandler = (Bool) -> Void

class StoryTimerProgressBar: UIView {
    // MARK: - Private Properties
    
    private lazy var progressBar: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: frame.height)))
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bindings: StoryTimerBindings = .init(
        start: start,
        resume: resume,
        pause: pause,
        complete: complete,
        reset: reset
    )
    
    private var viewModel: StoryTimerProgressBarViewModelProtocol
    
    override var bounds: CGRect {
        didSet {
            if viewModel.hasCompleted == true {
                complete()
            } else {
                reset()
            }
        }
    }
    
    // MARK: - Lifecycle

    init(with viewModel: StoryTimerProgressBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        viewModel.bind(bindings)
        setupView()
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension StoryTimerProgressBar {
    
}

// MARK: - Private Methods - Bar Control

private extension StoryTimerProgressBar {
    func start(with duration: TimeInterval) {
        progressBar.frame.size.height = frame.size.height
        UIView.animate(withDuration: duration, delay: .zero, options: [.curveLinear], animations: {
            self.progressBar.frame.size.width = self.frame.size.width
        }) { isCompleted in
            self.viewModel.animationHasFinished(isCompleted: isCompleted)
        }
    }
    
    func resume() {
        let pausedTime: CFTimeInterval = progressBar.layer.timeOffset
        progressBar.layer.speed = 1.0
        progressBar.layer.timeOffset = 0.0
        progressBar.layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval =  progressBar.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressBar.layer.beginTime = timeSincePause
    }
    
    func pause() {
        let pausedTime: CFTimeInterval = progressBar.layer.convertTime(CACurrentMediaTime(), from: nil)
        progressBar.layer.speed = 0.0
        progressBar.layer.timeOffset = pausedTime
    }
    
    func complete() {
        progressBar.layer.removeAllAnimations()
        progressBar.frame.size.height = frame.size.height
        progressBar.frame.size.width = frame.size.width
    }
    
    func reset() {
        progressBar.layer.removeAllAnimations()
        progressBar.frame.size.width = .zero
        progressBar.layer.speed = 1.0
    }
}

// MARK: - Private Methods - Setup

private extension StoryTimerProgressBar {
    
    func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.4)
        layer.cornerRadius = 2
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
    }
    
    func setupProgressBar() {
        addSubview(progressBar)
    }
}
