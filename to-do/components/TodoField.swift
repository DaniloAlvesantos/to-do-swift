import UIKit

class TodoField: UIStackView {
    public let identifier: String = "TodoField\(Int.random(in: 1..<100))"
    
    private lazy var todoCheckbox: CustomCheckbox = {
       return CustomCheckbox()
    }()

    private lazy var todoTextField: CustomTextField = {
        return CustomTextField()
    }()
    
    private lazy var deleteButtonIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "trash"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(destruction))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setUpStackView()
    }
    
    private func setUpStackView() {
        self.addArrangedSubview(todoCheckbox)
        self.addArrangedSubview(todoTextField)
        self.addArrangedSubview(deleteButtonIcon)
        
        todoCheckbox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        setUpDefaultStyles()
        setUpConstraints()
    }
    
    @objc func checkBoxTapped() -> Void {
        deleteButtonIcon.tintColor = todoCheckbox.isChecked ? .gray : .systemBlue
        todoTextField.textColor = todoCheckbox.isChecked ? .gray : .black
        if(todoCheckbox.isChecked) {
            todoCheckbox.backgroundColor = .gray
            todoCheckbox.layer.borderColor = UIColor.gray.cgColor
        } else {
            todoCheckbox.setDefaultStyle()
        }
    }
                                               
    @objc func destruction() -> Void {
        if(todoTextField.isEditing) {
            return;
        }
        
        todoTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }) { isFinished in
            if(isFinished) {
                self.removeFromSuperview()
            }
        }
    }
    
    private func setUpDefaultStyles(){
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        
        alignment = .center
        distribution = .equalSpacing
        spacing = 8
    }
    
    public func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
