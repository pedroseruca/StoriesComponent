import UIKit

final class StoriesGroupCell: UICollectionViewCell {
    private let imageView = RoundedImageView()

    private let namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.clearImage()
    }

    // MARK: - Internal Methods

    func configure(with viewModel: StoriesGroupCellViewModelProtocol) {
        namelabel.text = viewModel.name
        imageView.setImage(from: viewModel.imageURL)
    }
}

// MARK: - Private Methods

private extension StoriesGroupCell {
    func setupViews() {
        addSubview(imageView)
        addSubview(namelabel)
    }

    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.StoriesGroupCell.edgeSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.StoriesGroupCell.edgeSize),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.StoriesGroupCell.topBottomMargin),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)]
        )

        namelabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            namelabel.leftAnchor.constraint(equalTo: leftAnchor),
            namelabel.rightAnchor.constraint(equalTo: rightAnchor),
            namelabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.StoriesGroupCell.topBottomMargin)]
        )
    }
}
