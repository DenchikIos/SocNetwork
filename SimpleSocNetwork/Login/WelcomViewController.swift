import UIKit

final class WelcomViewController: UIViewController {
    
    private lazy var buttomRegistrerAction: (() -> Void) = {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    private lazy var buttomLoginAction: (() -> Void) = {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    private lazy var mainScrollView = CustomScrollView()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var signupButton = CustomButton(titleText: "REGISTER", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: UIColor(named: "butttonBackgroundBlack")!, tapAction: buttomRegistrerAction)
    
    private lazy var loginButton = CustomButton(titleText: "login to your account", titleSize: 19, titleColor: UIColor(named: "textMainBlack")!, backgroundColor: UIColor(named: "backgroundMainGray")!, tapAction: buttomLoginAction)
    
    private lazy var emptyLable = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        view.addSubviews(mainScrollView)
        mainScrollView.addSubviews(logoImageView, signupButton, loginButton, emptyLable)
        view.backgroundColor = UIColor(named: "backgroundMainGray")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 344),
            logoImageView.widthAnchor.constraint(equalToConstant: 344),
            logoImageView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 80),
            
            signupButton.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            signupButton.heightAnchor.constraint(equalToConstant: 47),
            signupButton.widthAnchor.constraint(equalToConstant: 261),
            
            loginButton.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 20),
            loginButton.widthAnchor.constraint(equalTo: signupButton.widthAnchor),
            
            emptyLable.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            emptyLable.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            emptyLable.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -50),
        ])
    }
    
}
