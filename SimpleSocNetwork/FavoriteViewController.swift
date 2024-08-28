import UIKit

final class FavoriteViewController: UIViewController {
    
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?

    private lazy var favoriteTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
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
        favoriteTableView.reloadData()
        profile = CurrentProfileService.shared.currentProfile
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(favoriteTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.favoritesPosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {return UITableViewCell(frame: .zero)}
        if let post = profile?.favoritesPosts?.allObjects[indexPath.row] as? PostData {
            cell.updateCell(post: post)
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] _,_,_ in
            guard let self else { return }
            if let post = self.profile?.favoritesPosts?.allObjects[indexPath.row] as? PostData {
                self.profile?.removeFromFavoritesPosts(post)
                self.coreDataService.saveContext()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor(named: "textMainBlack")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension FavoriteViewController: UpdateTableViewDelegate {
    
    func updateTableView() {
        favoriteTableView.reloadData()
    }
    
}
