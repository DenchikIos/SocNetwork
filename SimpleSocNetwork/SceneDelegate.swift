import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        if CurrentProfileService.shared.featchCurrentProfile() == nil {
            window.rootViewController = UINavigationController(rootViewController: WelcomViewController())
        } else {
            CoreDataService.shared.getUser()
            window.rootViewController = MainTabBarController()
        }
        self.window = window
        window.makeKeyAndVisible()
    }

}
