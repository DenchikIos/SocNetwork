import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "photosTableViewCell"
    
    private lazy var photoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(named: "textMainWhite")!.cgColor
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubviews(photoImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func setupCell(photo: PhotoData?) {
        photoImage.image = UIImage(named: photo?.image ?? "unknown")
    }
}
