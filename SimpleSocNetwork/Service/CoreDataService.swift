import CoreData
import Foundation

final class CoreDataService{
   
    static let shared = CoreDataService()
    
    public lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleSocNetwork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private init(){}
    
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    public func chekcProfile(for numberPhone: String?, completion: ((ProfileData?) -> Void)?) {
        guard let numberPhone else {return}
        let fetchRequest: NSFetchRequest<ProfileData> = ProfileData.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "phone == %@", numberPhone)
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                completion?(nil)
                return
            }
            completion?(result.first)
        } catch let error {
            print("chekcProfile ERROR: \(error)")
        }
    }
    
    public func createProfile(with phoneNumber: String) {
        let profile = ProfileData(context: context)
        profile.id = UUID()
        profile.phone = phoneNumber
        profile.dayBirth = "unknown"
        profile.name = "unknown"
        profile.surname = "unknown"
        profile.userAvatar = "unknown"
        profile.hometown = "unknown"
        profile.userJob = "unknown"
        profile.photos = []
        profile.posts = []
        profile.favoritesPosts = []
        profile.followers = []
        profile.subscriptions = []
        saveContext()
    }
    
    public func getUser() {
        guard let profilePhoneNumber = CurrentProfileService.shared.featchCurrentProfile() else {return}
        let fetchRequest: NSFetchRequest<ProfileData> = ProfileData.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "phone == %@", profilePhoneNumber)
        do {
            guard let result = try context.fetch(fetchRequest).first else {return}
            CurrentProfileService.shared.currentProfile = result
        } catch let error {
            print("ERROR: \(error)")
        }
    }
    
    public func createPost(image: String?, text: String?) -> PostData {
        let post = PostData(context: context)
        post.id = UUID()
        post.image = image
        post.descriptions = text
        saveContext()
        return post
    }
    
    public func deletePost(post: PostData) {
        persistentContainer.viewContext.delete(post)
        saveContext()
    }
    
    public func createPhoto(image: String) -> PhotoData {
        let photo = PhotoData(context: context)
        photo.id = UUID()
        photo.image = image
        saveContext()
        return photo
    }
    
    public func deletePhoto(photo: PhotoData) {
        persistentContainer.viewContext.delete(photo)
        saveContext()
    }
    
    public func createStories(image: String) -> PhotoData {
        let stories = PhotoData(context: context)
        stories.id = UUID()
        stories.image = image
        saveContext()
        return stories
    }
    
    public func firstStart() {
        var random = 0
        while random < 10 {
          random += 1
            let newProfile = createFirstFriends()
            if Bool.random() {
                CurrentProfileService.shared.currentProfile?.addToFollowers(newProfile)
                CoreDataService.shared.saveContext()
            } else {
                CurrentProfileService.shared.currentProfile?.addToSubscriptions(newProfile)
                CoreDataService.shared.saveContext()
            }
        }
    }
    
    private func createFirstFriends() -> ProfileData {
        let profile = ProfileData(context: context)
        let names = ["Ivan", "Petr", "Gnom", "Fedor", "Viktor", "Alex", "Feofan"]
        let surname = ["Cat", "Coolio", "Cent", "Chrom", "Gose", "Romanov", "Tramp"]
        let dayBirths = ["11.02.1957", "25.07.1977", "17.12.1999"]
        let hometowns = ["Penza", "Tombov", "London"]
        let jobs = ["doctor", "policman", "engineer"]
        let userImages = ["exampleAvatar1", "exampleAvatar2", "exampleAvatar3", "exampleAvatar4", "exampleAvatar5", "exampleAvatar6", "exampleAvatar7", "exampleAvatar8"]
        let postText = ["hello word", "I am not a Robot", "Random Text"]
        let randomImage = createPhoto(image: userImages.randomElement() ?? "unknown")
        let randomPost = createPost(image: userImages.randomElement(), text: postText.randomElement())
        profile.id = UUID()
        profile.phone = "+1" + String(Int.random(in: 10000000..<100000000))
        profile.dayBirth = dayBirths.randomElement()
        profile.name = names.randomElement()
        profile.surname = surname.randomElement()
        profile.userAvatar = userImages.randomElement()
        profile.hometown = hometowns.randomElement()
        profile.userJob = jobs.randomElement()
        profile.photos = [randomImage, randomImage]
        profile.stories = createStories(image: userImages.randomElement() ?? "unknown")
        profile.posts = [randomPost, randomPost]
        profile.favoritesPosts = []
        profile.followers = []
        profile.subscriptions = []
        saveContext()
        return profile
    }
    
}

extension ProfileData {
    
    func changeSubscribeState(for profile: ProfileData) {
        profile.isFollower(profile: self) == true ? unsubscribeTo(profile: profile) : subscribeTo(profile: profile)
    }
    
    private func subscribeTo(profile: ProfileData) {
        self.addToSubscriptions(profile)
        profile.addToFollowers(self)
        try? managedObjectContext?.save()
    }
    
    private func unsubscribeTo(profile: ProfileData) {
        self.removeFromSubscriptions(profile)
        profile.removeFromFollowers(self)
        try? managedObjectContext?.save()
    }
    
    func isFollower(profile: ProfileData) -> Bool? {
        self.followers?.contains(profile)
    }
    
    func isSubscriber(profile: ProfileData) -> Bool? {
        self.subscriptions?.contains(profile)
    }
    
    func changeFavoritePostState(for post: PostData) {
        self.isFavoritePost(post: post) == true ? unfavoritePostTo(post: post) : favoritePostTo(post: post)
    }
    
    func isFavoritePost(post: PostData) -> Bool? {
        self.favoritesPosts?.contains(post)
    }
    
    private func favoritePostTo(post: PostData) {
        self.addToFavoritesPosts(post)
        try? managedObjectContext?.save()
    }
    
    private func unfavoritePostTo(post: PostData) {
        self.removeFromFavoritesPosts(post)
        try? managedObjectContext?.save()
    }
    
}
