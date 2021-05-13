import UIKit

final class AspectImageView: UIImageView {
    
    // MARK: - Public Properties
    
    override var image: UIImage? {
        didSet {
            updateAspectRatio()
            backgroundColor = image?.averageColor
        }
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateAspectRatio()
    }
}

// MARK: - Private Methods

private extension AspectImageView {
    func updateAspectRatio() {
        guard let image = image else { return }
        let viewAspectRatio = bounds.width / bounds.height
        let imageAspectRatio = image.size.width / image.size.height
        if viewAspectRatio > imageAspectRatio {
            contentMode = .scaleAspectFill
        } else {
            contentMode = .scaleAspectFit
        }
    }
    
    
}
