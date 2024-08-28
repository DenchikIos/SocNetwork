import UIKit

final class RegisterViewController: UIViewController {
    
    private var coreDataService = CoreDataService.shared

    private var checkerPhoneNumber: String {
        get {""}
        set (aNewValue) {
            if (aNewValue.count > 16) {
                showNextButton()
            } else {
                hidenNextButton()
            }
        }
    }

    private lazy var buttonRegisterFinishAction: (() -> Void) = {
        self.tryToRegistrateNewProfile()
    }
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = CustomScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var textTitleLabel = CustomLabel(labelText: "REGISTER", fontsize: 22, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
    
    private lazy var phoneLabel = CustomLabel(labelText: "Enter the number", fontsize: 24, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
   
    private lazy var descriptionLabel = CustomLabel(labelText: "Your number will be used to log in to your account", fontsize: 12, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
    
    private lazy var phoneTextField: UITextField = {
        let textField = CustomTextField(textHolder: "+7(___)___-__-__", colorText: UIColor(named: "textMainBlack")!, cornerRadius: 12)
        textField.layer.borderWidth = 1.0
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.statusOfTextFielrd = .onlyPhoneNumber
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = CustomButton(titleText: "NEXT", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: UIColor(named: "butttonBackgroundBlack")!, tapAction: buttonRegisterFinishAction)
        button.alpha = 0.2
        button.isEnabled = false
        return button
    }()
    
    private lazy var descriptionBottonLabel: UILabel = {
        let label = CustomLabel(labelText: "By clicking the “Next” button You accept the User Agreement and the privacy policy", fontsize: 12, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        label.alpha = 0.2
        return label
    }()
    
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
        autoHideTheKeyboard(mainScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscriptKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unSubscriptKeyboardEvents()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundMainGray")
        view.addSubviews(mainScrollView)
        mainScrollView.addSubviews(textTitleLabel, phoneLabel, descriptionLabel, phoneTextField, nextButton, descriptionBottonLabel, emptyLable)
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
            
            phoneLabel.topAnchor.constraint(equalTo: textTitleLabel.bottomAnchor, constant: 70),
            phoneLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            phoneLabel.heightAnchor.constraint(equalToConstant: 24),
            
            descriptionLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 215),
            
            phoneTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 23),
            phoneTextField.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 48),
            phoneTextField.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 57),
            phoneTextField.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -57),
            
            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 63),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 127),
            nextButton.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -128),
            
            descriptionBottonLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            descriptionBottonLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            descriptionBottonLabel.heightAnchor.constraint(equalToConstant: 85),
            descriptionBottonLabel.widthAnchor.constraint(equalToConstant: 200),
            
            emptyLable.centerXAnchor.constraint(equalTo: descriptionBottonLabel.centerXAnchor),
            emptyLable.topAnchor.constraint(equalTo: descriptionBottonLabel.bottomAnchor, constant: 10),
            emptyLable.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -10),
        ])
    }
    
    private func tryToRegistrateNewProfile() {
        coreDataService.chekcProfile(for: phoneTextField.text) { [self] (profile) in
            if profile != nil {
                showAllert(inputText: "This number has already been registered", exitAction: false)
                return
            } else {
                let viewController = FinishViewController()
                viewController.myPhoneNumber = phoneTextField.text
                viewController.registerType = .registered
                self.navigationController?.pushViewController(viewController, animated: true)
                return
            }
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
        nextButton.alpha = 1
        nextButton.isEnabled = true
        descriptionBottonLabel.alpha = 1
    }
    
    private func hidenNextButton() {
        nextButton.alpha = 0.2
        nextButton.isEnabled = false
        descriptionBottonLabel.alpha = 0.2
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            mainScrollView.contentOffset.y = keyboardSize.height - (mainScrollView.frame.height - emptyLable.frame.minY)
            mainScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        checkerPhoneNumber = textField.text ?? ""
    }
    
}
