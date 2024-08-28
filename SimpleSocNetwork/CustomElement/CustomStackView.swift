import UIKit

final class CustomStackView: UIStackView{
    
    init(space: CGFloat?, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) {
        super.init(frame: .zero)
        self.spacing = space ?? 0
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
