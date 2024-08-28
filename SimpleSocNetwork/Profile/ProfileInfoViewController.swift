import UIKit

final class ProfileInfoViewController: UIViewController {
    
    private var profile: ProfileData?
    private var ratioFrame: Double = 0.0
    
    private lazy var closeViewController: (() -> Void) = {
        self.wrapScreen()
    }
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "textMainBlack")?.cgColor
        return view
    }()
    
    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel(labelText: "Profile", fontsize: 21, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var nameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var surnameLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var phoneLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var dayBirthLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var hometownLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var userJobLabel: CustomLabel = {
        let label = CustomLabel(labelText: "unknown", fontsize: 18, fontColor: UIColor(named: "textMainBlack")!, alignment: .left)
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = CustomButton(titleText: "", titleSize: 0, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: UIColor(named: "backgroundMainGray")!, tapAction: closeViewController)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.imageView?.tintColor = .systemOrange
        return button
    }()
    
    private lazy var mainVerticalStack: CustomStackView = {
        let stackView = CustomStackView(space: 0, axis: .vertical, distribution: .equalCentering, alignment: .leading)
        return stackView
    }()
    
    init(profile: ProfileData?) {
        super.init(nibName: nil, bundle: nil)
        self.profile = profile
        setupUI()
        setupConstraints()
        currentProfileInfo(profile: profile)
        expandScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "textMainBlack")!.withAlphaComponent(0.4)
        view.addSubviews(infoView, cancelButton, titleLabel, mainVerticalStack)
        mainVerticalStack.addArrangedSubviews(nameLabel, surnameLabel, phoneLabel, dayBirthLabel, hometownLabel, userJobLabel)
        if UIDevice.current.orientation.isLandscape {
            ratioFrame = 0.50
        } else {
            ratioFrame = 0.30
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoView.heightAnchor.constraint(equalToConstant: view.bounds.size.height * ratioFrame),
            
            cancelButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -10),
            cancelButton.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            
            mainVerticalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            mainVerticalStack.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 30),
            mainVerticalStack.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -30),
            mainVerticalStack.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10),
        ])
    }
    
    private func currentProfileInfo(profile: ProfileData?) {
        nameLabel.text = "Name".localized + ": \(profile?.name ?? "unknown")"
        surnameLabel.text = "Surname".localized + ": \(profile?.surname ?? "unknown")"
        phoneLabel.text = "Phone".localized + ": \(profile?.phone ?? "unknown")"
        dayBirthLabel.text = "Birthday".localized + ": \(profile?.dayBirth ?? "unknown")"
        hometownLabel.text = "Hometown".localized + ": \(profile?.hometown ?? "unknown")"
        userJobLabel.text = "Job".localized + ": \(profile?.userJob ?? "unknown")"
    }
    
    private func expandScreen() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    private func wrapScreen() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
}
