import UIKit

final class PhotosViewController: UIViewController {
    
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupConstraints()
        setBackButton()
    }
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func showDeletePhotoAlert(indexPath : IndexPath) {
        let alertController = UIAlertController(title: "Warning".localized, message: "Delete photo?".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes".localized, style: .default) { _ in
            guard let photo = self.profile?.photos?.allObjects[indexPath.row] as? PhotoData else {return}
            self.coreDataService.deletePhoto(photo: photo)
            self.collectionView.deleteItems(at: [indexPath])
        }
        let cancelAction = UIAlertAction(title: "No".localized, style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func createLoongTap() {
        let loongTap = UILongPressGestureRecognizer(target: self, action: #selector(deleteTaping))
        loongTap.minimumPressDuration = 1.5
        collectionView.addGestureRecognizer(loongTap)
    }
    
    @objc private func deleteTaping(loongTap: UILongPressGestureRecognizer) {
        let cgpoint = loongTap.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: cgpoint) else {return}
        if loongTap.state != UIGestureRecognizer.State.ended {
            showDeletePhotoAlert(indexPath: indexPath)
        }
    }
    
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as? PhotosCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultcell", for: indexPath)}
        if let photo = profile?.photos?.allObjects[indexPath.item] as? PhotoData {
            cell.setupCell(photo: photo)
        }
        createLoongTap()
        return cell
    }
    
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 3
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = floor(accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let photo = profile?.photos?.allObjects[indexPath.row] as? PhotoData
        let fullPhoto = UIImageView()
        fullPhoto.image = UIImage(named: photo?.image ?? "unknown")
        fullPhoto.frame = UIScreen.main.bounds
        fullPhoto.backgroundColor = UIColor(named: "textMainBlack")
        fullPhoto.contentMode = .scaleAspectFit
        fullPhoto.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeFullScreenImage))
        fullPhoto.addGestureRecognizer(tap)
        self.view.addSubview(fullPhoto)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func closeFullScreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}
