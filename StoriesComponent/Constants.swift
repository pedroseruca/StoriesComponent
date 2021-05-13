
import UIKit

enum Constants {
    static let collectionHeight: CGFloat = 100
    
    static let collectionCellWidth: CGFloat = 80
    
    // MARK: - Imutable Constants
    
    static let collectionCellSize: CGSize = .init(width: collectionCellWidth, height: collectionHeight)
    
    enum StoriesGroupCell {
        static let topBottomMargin: CGFloat = 8
        static let edgeSize: CGFloat = 68
    }
    
    enum RoundedImageView {
        // it may not be needed
        static let size: CGSize = .init(width: 68, height: 68)
        
        enum OuterBorder {
            static let color: UIColor = .red
            static let width: CGFloat = 1
        }
        
        enum InnerBorder {
            static let color: UIColor = .white
            static let width: CGFloat = 2
        }
    }
}
