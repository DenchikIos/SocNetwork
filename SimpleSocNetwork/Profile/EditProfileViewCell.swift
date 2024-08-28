import UIKit

final class EditProfileViewCell: UITableViewCell {
    
    static var identifier = "EditProfileViewCell"
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: true)
        return toolBar
    }()
    
    private lazy var textField: CustomTextField = {
        let textField = CustomTextField(textHolder: "", colorText: UIColor(named: "textMainBlack")!,
                                        //.textMainBlack,
            cornerRadius: 10)
        textField.keyboardType = .namePhonePad
        textField.backgroundColor = .clear
        textField.textAlignment = .left
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        textField.delegate = self
        return textField
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
        contentView.addSubviews(textField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func updateCell(textholder: String, text: String?, isDatePicker: Bool, hiden: Bool) {
        textField.placeholder = "Enter".localized + " " + textholder.localized
        textField.text = text
        if !isDatePicker {
            textField.inputView = nil
            textField.inputAccessoryView = nil
        }
        textField.isHidden = hiden
    }
    
    public func returnedText() -> String? {
        textField.text
    }
    
    private func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        textField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func doneButtonPicker(){
        getDateFromPicker()
        self.contentView.endEditing(true)
    }
    
    @objc private func changedDate() {
        getDateFromPicker()
    }
    
}

extension EditProfileViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}
