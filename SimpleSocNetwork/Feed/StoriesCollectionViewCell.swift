import UIKit

final class StoriesCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "StoriesCollectionViewCell"
    
    private lazy var storiesImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "unknown"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemOrange.cgColor
        return imageView
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
        contentView.addSubviews(storiesImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            storiesImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            storiesImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            storiesImageView.heightAnchor.constraint(equalToConstant: 60),
            storiesImageView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func updateCell(stories: PhotoData) {
        guard let stories = stories.image else { return }
        storiesImageView.image = UIImage(named: stories)
    }
    
}
