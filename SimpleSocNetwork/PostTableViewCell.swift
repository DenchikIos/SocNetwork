import UIKit

final class PostTableViewCell: UITableViewCell {
    
    weak var delegate: UpdateTableViewDelegate?
    static var identifier = "PostTableViewCell"
    private var postInCell: PostData?
    private var profile: ProfileData?
    private var likeButtonCheck = false
    private var likeTotal = 0
    private var commitButtonCheck = false
    private var commitTotal = 0
    
    private lazy var changerLike: (() -> Void) = {
        self.changeLike()
    }
    
    private lazy var changerFavorite: (() -> Void) = {
        self.changeFavorite()
    }
    
    private lazy var changerCommit: (() -> Void) = {
        self.changeCommit()
    }
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 16, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var jobLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor.systemOrange
        button.transform = button.transform.rotated(by: .pi / 2)
        return button
    }()
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        return view
    }()
    
    private lazy var verticalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textMainBlack")
        return view
    }()
    
    private lazy var postTextLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "textMainWhite")
        return imageView
    }()
    
    private lazy var horizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let button = CustomButton(titleText: "\(likeTotal)", titleSize: 15, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: UIColor(named: "backgroundMainGray")!, tapAction: changerLike)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainBlack")
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var commitButton: UIButton = {
        let button = CustomButton(titleText: "\(commitTotal)", titleSize: 15, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: UIColor(named: "backgroundMainGray")!, tapAction: changerCommit)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainBlack")
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = CustomButton(titleText: "", titleSize: 0, titleColor: .systemOrange, backgroundColor: UIColor(named: "backgroundMainGray")!, tapAction: changerFavorite)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.imageView?.tintColor = .systemOrange
        button.contentMode = .scaleAspectFit
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profile = CurrentProfileService.shared.currentProfile
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "textMainWhite")
        contentView.addSubviews(avatarImageView, nameLabel, jobLabel, optionButton, backGroundView)
        backGroundView.addSubviews(verticalView, postTextLabel, postImageView, horizontalView, likeButton, commitButton, favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            jobLabel.heightAnchor.constraint(equalToConstant: 20),
            
            optionButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            backGroundView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backGroundView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            backGroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            verticalView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            verticalView.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 16),
            verticalView.widthAnchor.constraint(equalToConstant: 1),
            verticalView.bottomAnchor.constraint(equalTo: horizontalView.topAnchor, constant: -20),
            
            postTextLabel.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 5),
            postTextLabel.leadingAnchor.constraint(equalTo: verticalView.trailingAnchor, constant: 15),
            postTextLabel.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -10),
            
            postImageView.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: verticalView.trailingAnchor, constant: 15),
            postImageView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalToConstant: 125),
            
            horizontalView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            horizontalView.heightAnchor.constraint(equalToConstant: 1),
            horizontalView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            horizontalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: horizontalView.bottomAnchor, constant: 15),
            likeButton.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor, constant: 0),
            
            commitButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commitButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 30),
            
            favoriteButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -16),
            favoriteButton.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: -18),
        ])
    }
    
    public func updateCell(post: PostData?) {
        postInCell = post
        avatarImageView.image = UIImage(named: post?.profilePosts?.userAvatar ?? "unknown")
        nameLabel.text = "\(post?.profilePosts?.name ?? "unknown") \( post?.profilePosts?.surname ?? "unknown")"
        jobLabel.text = post?.profilePosts?.userJob ?? "unknown"
        postTextLabel.text = post?.descriptions
        postImageView.image = UIImage(named: post?.image ?? "unknown")
        setFavoriteImage()
    }
    
    private func setFavoriteImage() {
        guard let post = postInCell else {return}
        profile?.isFavoritePost(post: post) == true ? favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal) : favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
    
    private func changeFavorite() {
        guard let post = postInCell else { return }
        profile?.changeFavoritePostState(for: post)
        setFavoriteImage()
        delegate?.updateTableView()
    }
    
    private func changeCommit() {
        if commitButtonCheck == false {
            commitButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
            commitButtonCheck = true
        } else {
            commitButton.setImage(UIImage(systemName: "message"), for: .normal)
            commitButtonCheck = false
        }
    }
    
    private func changeLike() {
        if likeButtonCheck == false {
            likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            likeTotal += 1
            likeButton.setTitle("\(likeTotal)", for: .normal)
            likeButtonCheck = true
        } else {
            likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            likeTotal -= 1
            likeButton.setTitle("\(likeTotal)", for: .normal)
            likeButtonCheck = false
        }
    }
    
}
