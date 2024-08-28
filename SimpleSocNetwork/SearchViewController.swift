import UIKit
import CoreData

final class SearchViewController: UIViewController {
    
    private var profile: ProfileData?
    private var filteredProfiles = [ProfileData]()
    private var profiles = [ProfileData]()
    private var filteredPosts = [PostData]()
    private var posts = [PostData]()
    private var coreDataService = CoreDataService.shared
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Who are we looking for?".localized
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        return searchController
    }()
    
    private lazy var fetchProfileResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileData")
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataService.context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private lazy var fetchPostsResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostData")
        let sortDescription = NSSortDescriptor(key: "descriptions", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataService.context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 24
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .clear
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
        setupUI()
        setupConstraints()
        setBackButton()
        do {
            try fetchProfileResultController.performFetch()
            try fetchPostsResultController.performFetch()
        } catch let error {
            print("ERROR searchViewController: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profiles = fetchProfileResultController.fetchedObjects as? [ProfileData] ?? [ProfileData]()
        posts = fetchPostsResultController.fetchedObjects as? [PostData] ?? [PostData]()
    }
    
    private func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(searchTableView)
        if profile != nil {
            searchController.searchBar.placeholder = "What post are we looking for?".localized
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}

extension SearchViewController: UISearchControllerDelegate {
    
    private func filterContentForSearchText(_ searchText: String) {
        if profile == nil {
            filteredProfiles = profiles.filter({ (profile: ProfileData) -> Bool in
                let searchedText = (profile.name ?? "") + " " + (profile.surname ?? "")
                return searchedText.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredPosts = posts.filter({ (posts: PostData) -> Bool in
                return posts.descriptions?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        searchTableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profile == nil {
            return filteredProfiles.count
        } else {
            return filteredPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if profile == nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else { return UITableViewCell(frame: .zero)}
            let profile = filteredProfiles[indexPath.row]
            cell.updateCell(profile: profile)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell(frame: .zero)}
            let post = filteredPosts[indexPath.row]
            cell.updateCell(post: post)
            return cell
        }
        
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if profile == nil {
            let profile = filteredProfiles[indexPath.row]
            let profileSubscriber = ProfileViewController(profile: profile)
            profileSubscriber.navigationItem.leftItemsSupplementBackButton = true
            navigationController?.pushViewController(profileSubscriber, animated: true)
        }
    }
    
}
