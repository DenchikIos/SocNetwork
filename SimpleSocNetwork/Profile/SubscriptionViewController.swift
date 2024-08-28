import UIKit

final class SubscriptionViewController: UIViewController {
    
    private var coreDataService = CoreDataService.shared
    private var followers = [ProfileData]()
    private var subscriptions = [ProfileData]()
    private var filteredProfiles = [ProfileData]()
    
    public lazy var subscriptionSegmentControl: UISegmentedControl = {
        let segmenItems = ["Subscribers".localized, "Subscriptions".localized]
        let segmentedControl = UISegmentedControl(items: segmenItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = UIColor.systemOrange
        segmentedControl.backgroundColor = UIColor.init(named: "backgroundMainGray")
        //.backgroundMainGray
        let textColorSelected = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "textMainWhite")]
        //textMainWhite]
        let textColorNormal = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "textMainBlack")]
        //textMainBlack]
        segmentedControl.setTitleTextAttributes(textColorNormal as [NSAttributedString.Key : Any], for: .normal)
        segmentedControl.setTitleTextAttributes(textColorSelected as [NSAttributedString.Key : Any], for: .selected)
        return segmentedControl
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Who are we looking for?".localized
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        return searchController
    }()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private lazy var subscriptTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 24
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupConstraints()
        setBackButton()
        followers = CurrentProfileService.shared.currentProfile?.followers?.allObjects as? [ProfileData] ?? [ProfileData]()
        subscriptions = CurrentProfileService.shared.currentProfile?.subscriptions?.allObjects as? [ProfileData] ?? [ProfileData]()
        updateTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.init(named: "backgroundMainGray")
        //.backgroundMainGray
        view.addSubviews(subscriptTableView, subscriptionSegmentControl)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            subscriptionSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subscriptionSegmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            subscriptionSegmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            subscriptionSegmentControl.heightAnchor.constraint(equalToConstant: 44),
            
            subscriptTableView.topAnchor.constraint(equalTo: subscriptionSegmentControl.bottomAnchor),
            subscriptTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            subscriptTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            subscriptTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func segmentAction() {
        updateTableView()
    }
    
    private func updateTableView() {
        subscriptTableView.reloadData()
    }
    
}

extension SubscriptionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if !isFiltering {
            switch subscriptionSegmentControl.selectedSegmentIndex {
            case 0:
                returnValue = followers.count
                break
            case 1:
                returnValue = subscriptions.count
                break
            default:
                break
            }
        } else {
            returnValue = filteredProfiles.count
        }
        return returnValue
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else { return UITableViewCell(frame: .zero)}
        switch subscriptionSegmentControl.selectedSegmentIndex {
            case 0:
                if !isFiltering {
                    let follower = followers[indexPath.row]
                    cell.updateCell(profile: follower)
                } else {
                    let follower = filteredProfiles[indexPath.row]
                    cell.updateCell(profile: follower)
                }
                break
            case 1:
                if !isFiltering {
                    let subscription = subscriptions[indexPath.row]
                    cell.updateCell(profile: subscription)
                } else {
                    let subscription = filteredProfiles[indexPath.row]
                    cell.updateCell(profile: subscription)
                }
                break
            default:
                break
            }
        return cell
    }
    
}

extension SubscriptionViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var tempProfile: ProfileData?
        switch subscriptionSegmentControl.selectedSegmentIndex {
            case 0:
                let follower = followers[indexPath.row]
                tempProfile = follower
            case 1:
                let subscription = subscriptions[indexPath.row]
                tempProfile = subscription
            default:
                break
        }
        let viewController = ProfileViewController(profile: tempProfile)
        viewController.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] _,_,_ in
            guard let self else { return }
            switch self.subscriptionSegmentControl.selectedSegmentIndex {
            case 0:
                if let follower = CurrentProfileService.shared.currentProfile?.followers?.allObjects[indexPath.row] as? ProfileData {
                    CurrentProfileService.shared.currentProfile?.removeFromFollowers(follower)
                    self.followers.remove(at: indexPath.row)
                    self.coreDataService.saveContext()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case 1:
                if let subscription = CurrentProfileService.shared.currentProfile?.subscriptions?.allObjects[indexPath.row] as? ProfileData {
                    CurrentProfileService.shared.currentProfile?.removeFromSubscriptions(subscription)
                    self.subscriptions.remove(at: indexPath.row)
                    self.coreDataService.saveContext()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            default:
                break
            }
        }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor.init(named: "textMainBlack")
        //textMainBlack
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension SubscriptionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}

extension SubscriptionViewController: UISearchControllerDelegate {
    
    private func filterContentForSearchText(_ searchText: String) {
        switch subscriptionSegmentControl.selectedSegmentIndex {
        case 0:
            filteredProfiles = followers.filter({ (follower: ProfileData) -> Bool in
                let searchedText = (follower.name ?? "") + " " + (follower.surname ?? "")
                return searchedText.lowercased().contains(searchText.lowercased())
            })
            updateTableView()
        case 1:
            filteredProfiles = subscriptions.filter({ (subscription: ProfileData) -> Bool in
                let searchedText = (subscription.name ?? "") + " " + (subscription.surname ?? "")
                return searchedText.lowercased().contains(searchText.lowercased())
            })
            updateTableView()
        default:
            break
        }
    }
}
