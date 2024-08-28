import UIKit

final class CustomLabel: UILabel {
    
    init(labelText: String, fontsize: CGFloat, fontColor: UIColor, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        text = labelText.localized
        font = UIFont.systemFont(ofSize: fontsize, weight: .bold)
        textColor = fontColor
        numberOfLines = 0
        textAlignment = alignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
