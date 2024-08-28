import UIKit

final class ProfileViewController: UIViewController {
    
    private enum ImagePickerStyle {
        case changeAvatar, createStories, createPhoto
    }
    
    private var showAction: ImagePickerStyle = .changeAvatar
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?
        
    public lazy var profileIDLabel: CustomLabel = {
        let label = CustomLabel(labelText: "ID", fontsize: 16, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
        
    public lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 200
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        tableView.register(PostAndSearchHeaderView.self, forHeaderFooterViewReuseIdentifier: PostAndSearchHeaderView.identifier)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = UIColor(named: "backgroundMainGray")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupConstraints()
        updateTableView()
        setBackButton()
    }
        
    private func setupUI() {
        let settingBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill.badge.xmark"), style: .done, target: self, action: #selector(exitFromCurrentProfile))
        settingBarButtonItem.tintColor = UIColor.systemOrange
        let titleIDprofile = UIBarButtonItem(customView: profileIDLabel)
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.setLeftBarButton(titleIDprofile, animated: false)
        navigationItem.rightBarButtonItem = settingBarButtonItem
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(profileTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
        
    @objc private func exitFromCurrentProfile() {
        showAllert(inputText: "Do you really want to logout?", exitAction: true)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let photo = profile?.photos, photo.count > 0 {
                return 1
            }
            return 0
        case 1:
            return profile?.posts?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as? PhotosTableViewCell else {return UITableViewCell(frame: .zero)}
                let rightImageTap = UITapGestureRecognizer(target: self, action: #selector(openPhotosGallary))
                cell.updateCell(profile: profile, openGalleryAction: rightImageTap)
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {return UITableViewCell(frame: .zero)}
                let post = profile?.posts?.allObjects[indexPath.row] as? PostData
                cell.updateCell(post: post)
                return cell
            default:
                break
            }
        return UITableViewCell(frame: .zero)
    }
    
    @objc private func openPhotosGallary() {
        let viewController = PhotosViewController(profile: profile)
        viewController.title = "Photo gallery".localized + ": \(profile?.name ?? "unknown")"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0:
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.identifier) as? ProfileHeaderView else {return nil}
                header.updateHeader(profile: profile)
                let changeAvatarImageGusture = UITapGestureRecognizer(target: self, action: #selector(changeAvatarImage))
                header.avatarImageView.addGestureRecognizer(changeAvatarImageGusture)
                header.editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
                header.infoButton.addTarget(self, action: #selector(showProfileInfo), for: .touchUpInside)
    
                header.postButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
                header.storiesButton.addTarget(self, action: #selector(createStories), for: .touchUpInside)
                header.photoButton.addTarget(self, action: #selector(createPhoto), for: .touchUpInside)
                header.numberSubscriptionsButton.addTarget(self, action: #selector(showSubscription), for: .touchUpInside)
                header.numberSubscribersButton.addTarget(self, action: #selector(showSubscription), for: .touchUpInside)
                header.delegate = self
                return header
            case 1:
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostAndSearchHeaderView.identifier) as? PostAndSearchHeaderView else {return nil}
                if profile != CurrentProfileService.shared.currentProfile {
                    header.postLabel.text = "Posts".localized
                }
                header.searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
                return header
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] _,_,_ in
            guard let self else { return }
            if let post = self.profile?.posts?.allObjects[indexPath.row] as? PostData {
                self.coreDataService.deletePost(post: post)
                self.profileTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor(named: "textMainBlack")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showImagePicker(style: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = style
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func changeAvatarImage() {
        showAction = .changeAvatar
        showImagePicker(style: .photoLibrary)
    }
    
    @objc private func editProfile() {
        let viewController = EditProfileViewController(profile: profile)
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func showProfileInfo() {
        let viewController = ProfileInfoViewController(profile: profile)
        self.addChild(viewController)
        viewController.view.frame = view.frame
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    @objc private func createPost(sender: UIButton) {
        let viewController = AddPostViewController(profile: profile)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func createStories(sender: UIButton) {
        showAction = .createStories
        showImagePicker(style: .photoLibrary)
    }
    
    @objc private func createPhoto(sender: UIButton) {
        showAction = .createPhoto
        showImagePicker(style: .photoLibrary)
    }
    
    @objc private func showSubscription(sender: UIButton) {
        let viewController = SubscriptionViewController()
        viewController.title = "\(profile?.name ?? "unknown")"
        if sender.tag == 0 {
            viewController.subscriptionSegmentControl.selectedSegmentIndex = 0
        } else {
            viewController.subscriptionSegmentControl.selectedSegmentIndex = 1
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func showSearch() {
        let viewController = SearchViewController(profile: profile)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let profileHeader = self.profileTableView.headerView(forSection: 0) as? ProfileHeaderView
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {return}
        switch showAction {
            case .changeAvatar:
                DispatchQueue.main.async { [self] in
                    profileHeader?.avatarImageView.image = UIImage(named: "sample")
                    profile?.userAvatar = "sample"
                    coreDataService.saveContext()
                    profileTableView.reloadData()
                }
            case .createStories:
                picker.dismiss(animated: true, completion: nil)
                let viewController = StoriesViewController(profile: profile)
                let storiesData = "sample"
                let storiesNameText = transliterate(nonLatin: "\(profile?.name ?? "") \(profile?.surname ?? "")")
            viewController.updateViewController(forCreateStories: storiesData, forSetImageView: image, forSetNameText: storiesNameText, isPushButtonHiden: false)
                self.present(viewController, animated: true)
            case .createPhoto:
                let photo = coreDataService.createPhoto(image: "sample")
                profile?.addToPhotos(photo)
                DispatchQueue.main.async { [self] in
                    profileTableView.reloadData()
                }
                coreDataService.saveContext()
            }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UpdateTableViewDelegate {
    
    func updateTableView() {
        profileIDLabel.text = transliterate(nonLatin: "\(profile?.name ?? "") \(profile?.surname ?? "")")
        profileTableView.reloadData()
    }
    
}
