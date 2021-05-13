import StoriesComponent
import UIKit

final class PreviewController: UIViewController {
    // MARK: - Private Properties

    private let collectionViewModel = StoriesCollectionViewModel()

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        setupViews()
    }

    private func setupViews() {
        guard let navigationController = navigationController else { return }

        let collection = StoriesCollection(navigationController: navigationController)
        view.addSubview(collection)
        setupConstraints(collection)
        collection.configure(with: collectionViewModel)
    }

    private func setupConstraints(_ collection: UIView) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collection.topAnchor.constraint(equalTo: view.topAnchor),
                collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
}
