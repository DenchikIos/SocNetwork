import UIKit

final class FeedViewController: UIViewController {
    
    private var profile: ProfileData?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 32
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.register(FeedHeaderView.self, forHeaderFooterViewReuseIdentifier: FeedHeaderView.identifier)
        tableView.register(StoriesViewCell.self, forCellReuseIdentifier: StoriesViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = UIColor(named: "backgroundMainGray")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profile = CurrentProfileService.shared.currentProfile
        isPostOfSubscriptionIsHiden()
        mainTableView.reloadData()
    }
    
    private func setupUI() {
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchAction))
        searchBarButtonItem.tintColor = UIColor.systemOrange
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(mainTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func getSubscriptionPosts(profile: ProfileData?) -> [PostData] {
        var postsArray = [PostData]()
        profile?.subscriptions?.allObjects.forEach({ (subscription) in
            (subscription as? ProfileData)?.posts?.allObjects.forEach({ (post) in
                guard let post = post as? PostData else {return}
                postsArray.append(post)
            })
        })
        return postsArray
    }
    
    private func isPostOfSubscriptionIsHiden() {
        if (getSubscriptionPosts(profile: profile)).count > 0 {
            mainTableView.isHidden = false
        } else {
            mainTableView.isHidden = true
        }
    }
    
    @objc private func searchAction() {
        let searchViewController = SearchViewController(profile: nil)
        navigationController?.pushViewController(searchViewController, animated: true)
    }
   
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            let posts = getSubscriptionPosts(profile: profile)
            return posts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoriesViewCell.identifier, for: indexPath) as? StoriesViewCell else { return UITableViewCell(frame: .zero)}
                cell.getStories(profile: profile)
                cell.feedViewController = self
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell(frame: .zero) }
                let posts = getSubscriptionPosts(profile: profile)
                cell.updateCell(post: posts[indexPath.row])
                return cell
            default:
                return UITableViewCell(frame: .zero)
        }
    }

}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let posts = getSubscriptionPosts(profile: profile)
        let post = posts[indexPath.row]
        let viewController = ProfileViewController(profile: post.profilePosts)
        viewController.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 1:
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedHeaderView.identifier) as? FeedHeaderView else { return nil }
                return header
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
