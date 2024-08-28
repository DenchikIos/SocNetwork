import UIKit

final class AddPostViewController: UIViewController {
    
    weak var delegate: UpdateTableViewDelegate?
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?
    
    private lazy var deleteSelectedImage: (() -> Void) = {
        self.showCancelImageButton(switch: true)
    }
    
    private lazy var postTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = "What's new with you?".localized
  //      textView.textColor = UIColor.backgroundMainGray
        textView.font = .systemFont(ofSize: 18)
        textView.inputAccessoryView = toolBar
        textView.delegate = self
        return textView
    }()
    
    private lazy var cancelImageButton: UIButton = {
        let button = CustomButton(titleText: "", titleSize: 0, titleColor: .systemOrange, backgroundColor: .systemOrange, tapAction: deleteSelectedImage)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
 //       button.imageView?.tintColor = .textMainWhite
        button.isHidden = true
        return button
    }()
    
    private lazy var selectImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.backgroundColor = .systemOrange
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.sizeToFit()
        let addImageButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(addImageToolBar))
//        addImageButton.tintColor = UIColor.textMainBlack
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([addImageButton ,spaceButton], animated: true)
        return toolBar
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
        setupUI()
        setupConstraints()
        autoHideTheKeyboard(toolBar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        postTextView.resignFirstResponder()
    }
    
    private func setupUI() {
        view.addSubviews(postTextView, selectImageView, cancelImageButton)
        title = "Create a post".localized
  //      view.backgroundColor = .backgroundMainGray
        let pushBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .done, target: self, action: #selector(createPost))
        pushBarButtonItem.tintColor = UIColor.systemOrange
        let cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clear.fill"), style: .done, target: self, action: #selector(closeAddPostController))
        cancelBarButtonItem.tintColor = UIColor.systemOrange
        navigationItem.leftBarButtonItems = [cancelBarButtonItem]
        navigationItem.rightBarButtonItems = [pushBarButtonItem]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            postTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            cancelImageButton.trailingAnchor.constraint(equalTo: selectImageView.trailingAnchor, constant: -5),
            cancelImageButton.topAnchor.constraint(equalTo: selectImageView.topAnchor, constant: 5),
            cancelImageButton.heightAnchor.constraint(equalToConstant: 20),
            cancelImageButton.widthAnchor.constraint(equalToConstant: 20),
            
            selectImageView.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 10),
            selectImageView.heightAnchor.constraint(equalToConstant: 100),
            selectImageView.widthAnchor.constraint(equalToConstant: 100),
            selectImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            selectImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func showCancelImageButton(switch input: Bool) {
        selectImageView.isHidden = input
        cancelImageButton.isHidden = input
    }
    
    private func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addImageToolBar(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func createPost() {
        guard let textPost = postTextView.text else {return}
        let post = coreDataService.createPost(image: "sample", text: textPost)
        profile?.addToPosts(post)
        delegate?.updateTableView()
        exit()
    }
    
    @objc private func closeAddPostController() {
        exit()
    }
    
}

extension AddPostViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "What's new with you?".localized
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor(named: "backgroundMainGrayColor")
                    && !text.isEmpty {
            textView.textColor = UIColor(named: "textMainBlack")
            textView.text = text
            textView.font = .systemFont(ofSize: 18)
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor(named: "backgroundMainGray") {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}

extension AddPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] is UIImage else {return}
        self.selectImageView.image = UIImage(named: "sample")
        picker.dismiss(animated: true) {
        self.showCancelImageButton(switch: false)
        }
    }
}
