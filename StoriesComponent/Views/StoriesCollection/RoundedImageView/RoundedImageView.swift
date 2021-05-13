import UIKit

class RoundedImageView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = Constants.RoundedImageView.InnerBorder.width
        iv.layer.borderColor = Constants.RoundedImageView.InnerBorder.color.cgColor
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setImage(from url: URL?) {
        // handle download error
        guard let url = url else { return }
        
        imageView.setImage(from: url){ [weak self] in
            self?.backgroundColor = self?.afterImageSetBackgroundColor
        }
    }
    
    func clearImage() {
        backgroundColor = initialBackgroundColor
        imageView.image = nil
    }
    
    private lazy var initialBackgroundColor = Constants.RoundedImageView.InnerBorder.color
    private lazy var afterImageSetBackgroundColor = Constants.RoundedImageView.OuterBorder.color
}

// MARK: - Private Methods

private extension RoundedImageView {
    func setupViews() {
        clipsToBounds = true
        backgroundColor = initialBackgroundColor
        addSubview(imageView)
    }

    func setupConstraints() {
        layer.cornerRadius = frame.height / 2
        let borderWidth = Constants.RoundedImageView.OuterBorder.width
        imageView.frame = CGRect(x: borderWidth,
                                 y: borderWidth,
                                 width: frame.width - borderWidth * 2,
                                 height: frame.height - borderWidth * 2)
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
}
