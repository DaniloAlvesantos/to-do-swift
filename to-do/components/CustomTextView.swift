import UIKit

class CustomTextView: UITextView {
    public var isEditing: Bool = false
    public var onTextChanged: ((String) -> Void)?
    
    private var heightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setUpTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTextView() {
        setUpDefaultStyles()
        setUpConstraints()
    }

    public func setUpDefaultStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        
        text = ""
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        keyboardAppearance = .dark
        keyboardType = .default
        autocorrectionType = .no
        
        layer.cornerRadius = 8
        layer.borderWidth = 0
        
        isScrollEnabled = false
        
        delegate = self
    }

    private func setUpConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: 35)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300),
            heightConstraint
        ])
    }
    
    private func updateHeight() {
        layoutIfNeeded()
        let size = sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude))
        
        heightConstraint.constant = size.height
    }
}

extension CustomTextView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isEditing = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.isEditing = false
        layer.borderWidth = 0
        resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
        self.onTextChanged?(textView.text)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
