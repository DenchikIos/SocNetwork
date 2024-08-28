import UIKit

final class StoriesViewCell: UITableViewCell {
  
    weak var feedViewController: FeedViewController?
    static var identifier = "StoriesViewCell"
    private var stories: [PhotoData] = []
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: StoriesCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubviews(imageCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    public func getStories(profile: ProfileData?) {
        var photosArray = [PhotoData]()
        profile?.subscriptions?.allObjects.forEach({ (subscription) in
            if let stories = (subscription as? ProfileData)?.stories {
                photosArray.append(stories)
            }
        })
        stories = photosArray
        imageCollectionView.reloadData()
    }
   
}

extension StoriesViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionViewCell.identifier, for: indexPath) as? StoriesCollectionViewCell else {return UICollectionViewCell(frame: .zero)}
        cell.updateCell(stories: stories[indexPath.row])
        return cell
    }
    
}

extension StoriesViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectStories = stories[indexPath.row]
        let viewController = StoriesViewController(profile: nil)
        let storiesImage = UIImage(named: selectStories.image ?? "unknown")
        let nameLabelText = transliterate(nonLatin: "\(selectStories.profileStories?.name ?? "") \(selectStories.profileStories?.surname ?? "")")
        viewController.updateViewController(forCreateStories: nil, forSetImageView: storiesImage, forSetNameText: nameLabelText, isPushButtonHiden: true)
        viewController.modalPresentationStyle = .fullScreen
        feedViewController?.present(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }

}
