import UIKit

final class PhotosTableViewCell: UITableViewCell {
    
    static var identifier: String = "photosTableViewCell"
    private var profile: ProfileData?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "backgroundMainGray")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var countOfPhotos: CustomLabel = {
        let label = CustomLabel(labelText: "", fontsize: 16, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
        
    private lazy var rightArrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.right")
        image.tintColor = .systemOrange
        image.isUserInteractionEnabled = true
        return image
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
        contentView.backgroundColor = UIColor(named: "backgroundMainGray")
        contentView.addSubviews(countOfPhotos, rightArrowImage, collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countOfPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            countOfPhotos.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            
            rightArrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            rightArrowImage.centerYAnchor.constraint(equalTo: countOfPhotos.centerYAnchor),
            rightArrowImage.heightAnchor.constraint(equalToConstant: 24),
            rightArrowImage.widthAnchor.constraint(equalToConstant: 24),
            
            collectionView.heightAnchor.constraint(equalToConstant: 95),
            collectionView.topAnchor.constraint(equalTo: countOfPhotos.bottomAnchor,constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func updateCell(profile: ProfileData?, openGalleryAction: UIGestureRecognizer) {
        self.profile = profile
        countOfPhotos.text = "Photo gallery".localized + ": " + "\(profile?.photos?.count ?? 0) " + "pcs.".localized
        rightArrowImage.addGestureRecognizer(openGalleryAction)
        collectionView.reloadData()
    }
    
}

extension PhotosTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell()}
        let photo = profile?.photos?.allObjects[indexPath.row] as? PhotoData
        cell.setupCell(photo: photo)
        return cell
    }
    
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 4
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = floor(accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
