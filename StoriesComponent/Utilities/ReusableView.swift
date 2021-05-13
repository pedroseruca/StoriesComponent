import UIKit

// MARK: - ReusableView

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
    init()
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
extension UICollectionReusableView: ReusableView {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        "\(self)"
    }
    
    static var nib: UINib? {
        let type = "nib"
        let mainBundle = Bundle.main
        if mainBundle.path(forResource: reuseIdentifier, ofType: type) != nil {
            return UINib(nibName: reuseIdentifier, bundle: mainBundle)
        }

        let bundle = Bundle(for: Self.self)
        if bundle.path(forResource: reuseIdentifier, ofType: type) != nil {
            return UINib(nibName: reuseIdentifier, bundle: bundle)
        }

        return nil
    }
    
    init() {
        self.init(frame: CGRect.zero)
    }
}

// MARK: - UICollectionView extension

extension UICollectionView {

    // MARK: - Register

    func register<T: ReusableView> (_ cell: T.Type) {
        guard let nib = cell.nib else {
            register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
            return
        }
        register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func registerSectionHeader<T: ReusableView> (_ cell: T.Type) {
        guard let nib = cell.nib else {
            register(cell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cell.reuseIdentifier)
            return
        }
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cell.reuseIdentifier)
    }

    func registerSectionFooter<T: ReusableView>(_ footer: T.Type) {
        guard let nib = footer.nib else {
            register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footer.reuseIdentifier)
            return
        }
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footer.reuseIdentifier)
    }

    // MARK: - Dequeue

    func dequeue<T: ReusableView>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cell with identifier `\(T.reuseIdentifier)` not registered for type: `\(T.self)`!")
        }
        return cell
    }
    
    func supplementaryView<T: ReusableView>(forElementKind elementKind: String, at indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("🔥 SupplementaryView with identifier `\(T.reuseIdentifier)` not registered for type: `\(T.self)`!")
        }
        return supplementaryView
    }
}

// MARK: - UITableView extension

extension UITableView {
    
    // MARK: - Register
    
    func register<T: ReusableView> (_ cell: T.Type) {
        guard let nib = cell.nib else {
            register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
            return
        }
        register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    func registerHeaderFooter<T: ReusableView> (_ cell: T.Type) {
        guard let nib = cell.nib else {
            register(cell, forHeaderFooterViewReuseIdentifier: cell.reuseIdentifier)
            return
        }
        register(nib, forHeaderFooterViewReuseIdentifier: cell.reuseIdentifier)
    }

    // MARK: - Dequeue

    func dequeue<T: ReusableView>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cell with identifier `\(T.reuseIdentifier)` not registered for type: `\(T.self)`!")
        }
        return cell
    }

    func dequeueHeaderFooter<T: ReusableView>() -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Cell with identifier `\(T.reuseIdentifier)` not registered for type: `\(T.self)`!")
        }
        return cell
    }
}
