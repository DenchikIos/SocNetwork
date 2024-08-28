import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        UITabBar.appearance().tintColor = UIColor.systemOrange
        let feed = createNavigationController(viewController: FeedViewController(), title: "Feed".localized, imageIcon: "house.circle", tag: 0)
        let profile = createNavigationController(viewController: ProfileViewController(profile: CurrentProfileService.shared.currentProfile), title: "Profile".localized, imageIcon: "person.circle", tag: 1)
        let favorite = createNavigationController(viewController: FavoriteViewController(), title: "Favorites".localized, imageIcon: "heart.circle", tag: 2)
        self.tabBar.backgroundColor = UIColor(named: "navigationLightGrayBackground")
        self.viewControllers = [feed, profile, favorite]
    }
    
}
