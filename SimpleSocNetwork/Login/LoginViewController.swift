import UIKit

final class LoginViewController: UIViewController {
    
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
    
    private lazy var buttonLoginFinishAction: (() -> Void) = {
        self.tryToLogin()
    }
    
    private lazy var mainScrollView = CustomScrollView()
    
    private lazy var textTitleLabel: CustomLabel = {
        let label = CustomLabel(labelText: "Welcome back", fontsize: 22, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
    
    private lazy var textDescriptionLabel: CustomLabel = {
        let label = CustomLabel(labelText: "Enter your phone number to log in to the app", fontsize: 14, fontColor: UIColor(named: "textMainBlack")!, alignment: .center)
        return label
    }()
    
    private lazy var phoneTextField: CustomTextField = {
        let textField = CustomTextField(textHolder: "+7(___)___-__-__", colorText: UIColor(named: "textMainBlack")!, cornerRadius: 10)
        textField.layer.borderWidth = 1.0
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.statusOfTextFielrd = .onlyPhoneNumber
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var nextButton: CustomButton = {
        let button = CustomButton(titleText: "CONFIRM", titleSize: 19, titleColor: UIColor(named: "textMainWhite")!, backgroundColor: UIColor(named: "butttonBackgroundBlack")!, tapAction: buttonLoginFinishAction)
        button.alpha = 0.2
        button.titleLabel?.textAlignment = .center
        button.isEnabled = false
        return button
    }()
    
    private lazy var emptyLable = UILabel()

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
        mainScrollView.addSubviews(textTitleLabel, textDescriptionLabel, phoneTextField, nextButton, emptyLable)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textTitleLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 124),
            textTitleLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            textTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textDescriptionLabel.topAnchor.constraint(equalTo: textTitleLabel.bottomAnchor, constant: 26),
            textDescriptionLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            textDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            textDescriptionLabel.widthAnchor.constraint(equalToConstant: 189),
            
            phoneTextField.topAnchor.constraint(equalTo: textDescriptionLabel.bottomAnchor, constant: 12),
            phoneTextField.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 48),
            phoneTextField.widthAnchor.constraint(equalToConstant: 260),
            
            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 48),
            nextButton.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.widthAnchor.constraint(equalToConstant: 188),
            
            emptyLable.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            emptyLable.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            emptyLable.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -10),
        ])
    }
    
    private func showNextButton() {
        nextButton.alpha = 1
        nextButton.isEnabled = true
    }
    
    private func hidenNextButton() {
        nextButton.alpha = 0.2
        nextButton.isEnabled = false
    }
    
    private func tryToLogin() {
        coreDataService.chekcProfile(for: phoneTextField.text) { (profile) in
            if profile != nil {
                let viewController = FinishViewController()
                viewController.myPhoneNumber = self.phoneTextField.text
                viewController.registerType = .logined
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.showAllert(inputText: "This user is not registered", exitAction: false)
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
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let nextButtonPointY = self.nextButton.frame.origin.y + 48
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < nextButtonPointY ? nextButtonPointY - keyboardOriginY + 24 : 0
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        checkerPhoneNumber = textField.text ?? ""
    }
    
}
