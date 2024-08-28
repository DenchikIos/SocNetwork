import UIKit

final class CustomTextField: UITextField {
    
    enum StatusTextField {
        case onlyPhoneNumber, onlySMSCode, defaultTextFiled
    }
    
    var statusOfTextFielrd: StatusTextField = .defaultTextFiled
    
    init(textHolder: String, colorText: UIColor, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        placeholder = textHolder.localized
        textColor = colorText
        tintColor = .white
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor(named: "textMainBlack")?.cgColor
        //textMainBlack.cgColor
        textAlignment = .center
        clipsToBounds = true
        keyboardType = .default
        returnKeyType = .done
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftViewMode = .always
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch statusOfTextFielrd {
        case .onlyPhoneNumber:
            guard let currentText: String = textField.text else {return true}
            if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
            let newCount: Int = currentText.count + string.count - range.length
            let addingCharacter: Bool = range.length <= 0
            if(newCount == 1){
                textField.text = addingCharacter ? currentText + "+7 (\(string)" : String(currentText.dropLast(2))
                return false
            }else if(newCount == 8){
                textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
                return false
            }else if(newCount == 13){
                textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
                return false
            }
            if(newCount > 17){
                return false
            }
            return true
        case .onlySMSCode:
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        case .defaultTextFiled:
            return true
        }
    }
    
}

