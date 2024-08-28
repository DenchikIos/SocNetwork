import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    static var identifier = "ProfileHeaderView"
    weak var delegate: UpdateTableViewDelegate?
    private var coreDataService = CoreDataService.shared
    private var mainProfile = CurrentProfileService.shared.currentProfile
    private var currentProfile: ProfileData?

    public lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "unknown"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()

    private lazy var jobLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()

    public lazy var infoButton: UIButton = {
        let button = CustomButton(titleText: "Detailed information", titleSize: 12, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
        button.imageView?.tintColor = .systemOrange
        return button
    }()

    public lazy var editButton: UIButton = {
        let button = CustomButton(titleText: "Edit", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: .systemOrange, tapAction: nil)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private lazy var subscribersButtonStack: UIStackView = {
        let stackView = CustomStackView(space: 10, axis: .horizontal, distribution: .fillProportionally, alignment: .center)
        return stackView
    }()

    public lazy var messageButton: UIButton = {
        let button = CustomButton(titleText: "Message", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: .systemOrange, tapAction: nil)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    public lazy var subscribeButton: UIButton = {
        let button = CustomButton(titleText: "Subscribe", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: .systemOrange, tapAction: nil)
        button.addTarget(self, action: #selector(changeStatusButton), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private lazy var profileFillingStack: UIStackView = {
        let stackView = CustomStackView(space: 0, axis: .horizontal, distribution: .equalCentering, alignment: .center)
        return stackView
    }()

    private lazy var numberPublicationButton: UIButton = {
        let button = CustomButton(titleText: "Publications", titleSize: 19, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    public lazy var numberSubscriptionsButton: UIButton = {
        let button = CustomButton(titleText: "Subscriptions", titleSize: 19, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.tag = 1
        return button
    }()

    public lazy var numberSubscribersButton: UIButton = {
        let button = CustomButton(titleText: "Subscribers", titleSize: 19, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.tag = 0
        return button
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textMainBlack")
        return view
    }()
    
    private lazy var mediaButtonStack: UIStackView = {
        let stackView = CustomStackView(space: 0, axis: .horizontal, distribution: .fillEqually, alignment: .center)
        return stackView
    }()
    
    public lazy var postButton: UIButton = {
        let button = CustomButton(titleText: "Post", titleSize: 14, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainBlack")
        return button
    }()

    public lazy var storiesButton: UIButton = {
        let button = CustomButton(titleText: "History", titleSize: 14, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainBlack")
        return button
    }()

    public lazy var photoButton: UIButton = {
        let button = CustomButton(titleText: "Photo", titleSize: 14, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: .clear, tapAction: nil)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainBlack")
        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupUI() {
        contentView.addSubviews(avatarImageView, nameLabel, jobLabel, infoButton, editButton, subscribersButtonStack, profileFillingStack, bottomLineView, mediaButtonStack)
        subscribersButtonStack.addArrangedSubviews(messageButton, subscribeButton)
        profileFillingStack.addArrangedSubviews(numberPublicationButton, numberSubscriptionsButton, numberSubscribersButton)
        mediaButtonStack.addArrangedSubviews(postButton, storiesButton, photoButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            jobLabel.heightAnchor.constraint(equalToConstant: 22),
            
            infoButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            infoButton.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 3),
            infoButton.heightAnchor.constraint(equalToConstant: 22),
            
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 25),
            editButton.heightAnchor.constraint(equalToConstant: 47),
            
            subscribersButtonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subscribersButtonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subscribersButtonStack.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 25),
            subscribersButtonStack.heightAnchor.constraint(equalToConstant: 47),
            
            messageButton.heightAnchor.constraint(equalToConstant: 47),
            subscribeButton.heightAnchor.constraint(equalToConstant: 47),
            
            profileFillingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileFillingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileFillingStack.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),
            
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomLineView.topAnchor.constraint(equalTo: profileFillingStack.bottomAnchor, constant: 2),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            
            mediaButtonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mediaButtonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mediaButtonStack.topAnchor.constraint(equalTo: bottomLineView.bottomAnchor, constant: 15),
            mediaButtonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }

    public func updateHeader(profile: ProfileData?) {
        currentProfile = profile
        avatarImageView.image = UIImage(named: profile?.userAvatar ?? "unknown")
        nameLabel.text = (profile?.name ?? "unknown") + " " + (profile?.surname ?? "unknown")
        jobLabel.text = (profile?.userJob ?? "unknown")
        numberPublicationButton.setTitle("\(profile?.posts?.count ?? 0)\n" + "Publications".localized, for: .normal)
        numberSubscribersButton.setTitle("\(profile?.followers?.count ?? 0)\n" + "Subscribers".localized, for: .normal)
        numberSubscriptionsButton.setTitle("\(profile?.subscriptions?.count ?? 0)\n" + "Subscriptions".localized, for: .normal)
        if profile == mainProfile {
            avatarImageView.isUserInteractionEnabled = true
            editButton.isHidden = false
            subscribersButtonStack.isHidden = true
        } else {
            editButton.isHidden = true
            subscribersButtonStack.isHidden = false
            guard let tempProfile = profile else {return}
            if mainProfile?.isSubscriber(profile: tempProfile) == true {
                subscribeButton.setTitle("Unsubscribe".localized, for: .normal)
            } else {
                subscribeButton.setTitle("Subscribe".localized, for: .normal)
            }
        }
    }

    @objc private func changeStatusButton() {
        guard let user = currentProfile else {return print("NIL USER")}
        mainProfile?.changeSubscribeState(for: user)
        delegate?.updateTableView()
    }

}
