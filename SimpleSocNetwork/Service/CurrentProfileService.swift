import Foundation

final class CurrentProfileService {
    
    static let shared = CurrentProfileService()
    
    var currentProfile: ProfileData?
    
    private init(){}
    
    func setCurrentProfile(with phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: "phone")
    }
    
    func removeCurrentProfile() {
        UserDefaults.standard.removeObject(forKey: "phone")
    }
    
    func featchCurrentProfile() -> String? {
        UserDefaults.standard.string(forKey: "phone")
    }
    
}
