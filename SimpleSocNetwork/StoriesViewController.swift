import UIKit

final class StoriesViewController: UIViewController {
    
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?
    private var storiesImage: String?
    
    private lazy var buttonDissmissAction: (() -> Void) = {
        self.dissmissViewController()
    }
    
    private lazy var buttonPushStoriesAction: (() -> Void) = {
        self.pushStories()
    }
    
    private lazy var storiesImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 12, fontColor: UIColor(named: "textMainWhite")!, alignment: .center)
        label.backgroundColor = UIColor.systemOrange
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = CustomButton(titleText: "", titleSize: 12, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: .systemOrange, tapAction: buttonDissmissAction)
        button.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "textMainWhite")
        return button
    }()
    
    private lazy var pushStoriesButton: CustomButton = {
        let button = CustomButton(titleText: "Share", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: .systemOrange, tapAction: buttonPushStoriesAction)
        button.contentVerticalAlignment = .center
        return button
    }()
    
    init(profile: ProfileData?) {
        super.init(nibName: nil, bundle: nil)
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubviews(storiesImageView, nameLabel, exitButton, pushStoriesButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            storiesImageView.topAnchor.constraint(equalTo: view.topAnchor),
            storiesImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storiesImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storiesImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: storiesImageView.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: storiesImageView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: 17),
            nameLabel.widthAnchor.constraint(equalToConstant: 110),
            
            exitButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: storiesImageView.trailingAnchor, constant: -15),
            exitButton.heightAnchor.constraint(equalToConstant: 25),
            exitButton.widthAnchor.constraint(equalToConstant: 25),
            
            pushStoriesButton.trailingAnchor.constraint(equalTo: storiesImageView.trailingAnchor, constant: -15),
            pushStoriesButton.bottomAnchor.constraint(equalTo: storiesImageView.bottomAnchor, constant: -35),
        ])
    }
    
    public func updateViewController(forCreateStories: String?, forSetImageView: UIImage?, forSetNameText: String?, isPushButtonHiden: Bool) {
        storiesImage = forCreateStories
        self.storiesImageView.image = forSetImageView
        self.nameLabel.text = forSetNameText
        self.pushStoriesButton.isHidden = isPushButtonHiden
    }
    
    private func dissmissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func pushStories() {
        guard let newImage = storiesImage else {return}
        let stories = coreDataService.createStories(image: newImage)
        profile?.stories = stories
        coreDataService.saveContext()
        dissmissViewController()
    }
    
}
