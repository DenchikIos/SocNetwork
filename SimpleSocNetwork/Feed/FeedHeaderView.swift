import UIKit

final class FeedHeaderView: UITableViewHeaderFooterView {
    
    static var identifier = "MainHeaderView"
    
    private lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textMainBlack")
        return view
    }()
    
    private lazy var subscriberTitleLabel: CustomLabel = {
        let label = CustomLabel(labelText: "Subscriber posts", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textMainBlack")
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubviews(leftView, subscriberTitleLabel, rightView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftView.heightAnchor.constraint(equalToConstant: 1),
            leftView.trailingAnchor.constraint(equalTo: subscriberTitleLabel.leadingAnchor, constant: -10),
            
            rightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightView.heightAnchor.constraint(equalToConstant: 1),
            rightView.leadingAnchor.constraint(equalTo: subscriberTitleLabel.trailingAnchor, constant: 10),
            
            subscriberTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subscriberTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subscriberTitleLabel.widthAnchor.constraint(equalToConstant: 144),
            subscriberTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
}
