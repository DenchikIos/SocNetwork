import UIKit

final class SearchViewCell: UITableViewCell {
    
    static var identifier: String = "SearchViewCell"
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unknown"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 16, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var jobLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 14, fontColor: UIColor(named: "textMainWhite")!, alignment: .left)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
        contentView.layer.borderWidth = 1
        contentView.addSubviews(avatarImageView, nameLabel, jobLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            jobLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    public func updateCell(profile: ProfileData) {
        avatarImageView.image = UIImage(named: profile.userAvatar ?? "unknown")
        nameLabel.text = "\(profile.name ?? "unknown") \(profile.surname ?? "unknown")"
        jobLabel.text = profile.userJob ?? "unknown"
    }
    
}
