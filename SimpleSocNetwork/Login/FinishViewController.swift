import UIKit

final class FinishViewController: UIViewController {
    
    enum RegisterType {
        case registered, logined
    }
    
    private var coreDataService = CoreDataService.shared
    private var currentProfileService = CurrentProfileService.shared
    private let imitationOfSMS = Int.random(in: 1000..<10000)
    private var codeFromSMS = Int()
    var registerType: RegisterType = .registered
    var myPhoneNumber: String?
    
    private var checkerCode: Int {
        get {0}
        set (aNewValue) {
            if (aNewValue > 999) {
                showNextButton()
            } else {
                hidenNextButton()
            }
        }
    }
    
    private lazy var buttonMainTabBarAction: (() -> Void) = {
        self.registerNewProfileOrLogined(with: self.myPhoneNumber)
    }
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = CustomScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    public lazy var textTitleLabel: CustomLabel = {
        let textLabel: String = registerType == .registered ? "Confirmation of registration" : "Login Confirmation"
        let label = CustomLabel(labelText: textLabel, fontsize: 22, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
    
    private lazy var textDescriptionLabel: CustomLabel = {
        let label = CustomLabel(labelText: "We sent an SMS with a code to the number".localized + "\n\(myPhoneNumber ?? "")", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
    
    private lazy var textEnterSMSLabel: CustomLabel = {
        let label = CustomLabel(labelText: "Enter the code from the SMS", fontsize: 15, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
    
    public lazy var enterSMSTextField: CustomTextField = {
        let textField = CustomTextField(textHolder: "__-__", colorText: UIColor(named: "textMainBlack")!, cornerRadius: 10)
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.layer.borderWidth = 1.0
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.statusOfTextFielrd = .onlySMSCode
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    public lazy var registerButton: CustomButton = {
        let textButton: String = registerType == .registered ? "REGISTER" : "ENTER"
        let button = CustomButton(titleText: textButton, titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: UIColor(named: "butttonBackgroundBlack")!, tapAction: buttonMainTabBarAction)
        button.alpha = 0.2
        button.isEnabled = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyLable = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        autoHideTheKeyboard(mainScrollView)
        createNotificationContect(codeSMS: imitationOfSMS)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscriptKeyboardEvents()
        print(imitationOfSMS)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unSubscriptKeyboardEvents()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(mainScrollView)
        mainScrollView.addSubviews(textTitleLabel, textDescriptionLabel, textEnterSMSLabel, enterSMSTextField, registerButton, checkImageView, emptyLable)
        setBackButton()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textTitleLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 60),
            textTitleLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            textTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textDescriptionLabel.topAnchor.constraint(equalTo: textTitleLabel.bottomAnchor, constant: 12),
            textDescriptionLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            textDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            textEnterSMSLabel.topAnchor.constraint(equalTo: textDescriptionLabel.bottomAnchor, constant: 68),
            textEnterSMSLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            textEnterSMSLabel.heightAnchor.constraint(equalToConstant: 15),
            
            enterSMSTextField.topAnchor.constraint(equalTo: textEnterSMSLabel.bottomAnchor, constant: 5),
            enterSMSTextField.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            enterSMSTextField.heightAnchor.constraint(equalToConstant: 48),
            enterSMSTextField.widthAnchor.constraint(equalToConstant: 260),
            
            registerButton.topAnchor.constraint(equalTo: enterSMSTextField.bottomAnchor, constant: 46),
            registerButton.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 48),
            registerButton.widthAnchor.constraint(equalToConstant: 260),
            
            checkImageView.heightAnchor.constraint(equalToConstant: 86),
            checkImageView.widthAnchor.constraint(equalToConstant: 100),
            checkImageView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            checkImageView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 43),
            
            emptyLable.centerXAnchor.constraint(equalTo: checkImageView.centerXAnchor),
            emptyLable.topAnchor.constraint(equalTo: checkImageView.bottomAnchor, constant: 10),
            emptyLable.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -10),
        ])
    }
    
    private func registerNewProfileOrLogined(with phoneNumber: String?) {
        guard let phoneNumber else {return}
        if imitationOfSMS == codeFromSMS {
            if registerType == .registered {
                coreDataService.createProfile(with: phoneNumber)
            }
            currentProfileService.setCurrentProfile(with: phoneNumber)
            coreDataService.getUser()
            coreDataService.firstStart()
            let mainTabBarController = MainTabBarController()
            mainTabBarController.modalPresentationStyle = .fullScreen
            navigationController?.present(mainTabBarController, animated: true, completion: nil)
        } else {
            showAllert(inputText: "Enter the correct sms code", exitAction: false)
        }
    }
    
    private func subscriptKeyboardEvents() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unSubscriptKeyboardEvents() {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showNextButton() {
        registerButton.alpha = 1
        registerButton.isEnabled = true
    }
    
    private func hidenNextButton() {
        registerButton.alpha = 0.2
        registerButton.isEnabled = false
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        guard let numbers = textField.text else {return}
        codeFromSMS = Int(numbers) ?? 0
        checkerCode = Int(numbers) ?? 0
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let registerButtonPointY = self.registerButton.frame.origin.y + 48
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < registerButtonPointY ? registerButtonPointY - keyboardOriginY + 24 : 0
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
