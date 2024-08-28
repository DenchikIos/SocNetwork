import UIKit

final class CustomButton: UIButton {
    
    var someAction: (() -> Void)?
    
    init(titleText title: String, titleSize: CGFloat, titleColor color: UIColor, backgroundColor backGroundColor: UIColor, tapAction: (() -> Void)?){
        super.init(frame: .zero)
        setTitle(title.localized, for: .normal)
        setTitleColor(color, for: .normal)
        backgroundColor = backGroundColor
        titleLabel?.font = UIFont.boldSystemFont(ofSize: titleSize)
        layer.cornerRadius = 10.0
        self.someAction = tapAction
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(){
        someAction?()
    }
    
}
