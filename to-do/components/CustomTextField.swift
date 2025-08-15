import UIKit

class CustomTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextField() {
        setUpDefaultStyles()
        setUpConstraints()
    }
    
    public func setUpDefaultStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = "Type..."
        borderStyle =  .none
        keyboardAppearance = .dark
        keyboardType = .default
        returnKeyType = .done
        autocorrectionType = .no
        contentVerticalAlignment = .center
        delegate = self
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 300),
            self.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderStyle = .roundedRect
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        borderStyle = .none
        self.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        borderStyle = .none
        return true
    }
}
