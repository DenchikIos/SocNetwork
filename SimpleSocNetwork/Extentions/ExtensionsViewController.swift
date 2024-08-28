import UIKit

extension UIViewController {

    func setBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back".localized
        backButton.tintColor = UIColor(named: "textMainBlack")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func showAllert(inputText: String, exitAction: Bool) {
        let alertController = UIAlertController(title: "Warning".localized, message: inputText.localized, preferredStyle: .alert)
        if !exitAction {
            let agreelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(agreelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let cancelAction = UIAlertAction(title: "No".localized, style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Yes".localized, style: .default) { _ in
                CurrentProfileService.shared.removeCurrentProfile()
                CurrentProfileService.shared.currentProfile = nil
                let viewController = UINavigationController(rootViewController: WelcomViewController())
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)

        }
    }
    
    func createNavigationController(viewController: UIViewController, title: String, imageIcon: String, tag: Int) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = title
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageIcon), tag: tag)
        return navigationController
    }
    
    func autoHideTheKeyboard(_ view: UIView) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        view.addGestureRecognizer(recognizer)
    }

    @objc func touch() {
        self.view.endEditing(true)
    }
    
    func createNotificationContect(codeSMS: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        let content = UNMutableNotificationContent()
        content.title = "Simple Soc Network"
        content.subtitle = "iMassege"
        content.body = "\(codeSMS)"
        //notification counter on the app icon
        content.badge = 0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}

extension UIViewController: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //displaying the ios local notification when app is in foreground
        completionHandler([.banner, .badge, .sound])
    }
    
}
