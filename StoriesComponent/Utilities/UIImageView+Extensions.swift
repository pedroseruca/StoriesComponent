import UIKit

extension UIImageView {
    func setImage(from url: URL, completionOnSuccess: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completionOnSuccess?()
            }
        }
    }
}
