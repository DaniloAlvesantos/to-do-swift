import UIKit

struct ToDoFieldData {
    var text: String
    var isCompleted: Bool
}

class TodoField: UIStackView {
    public var identifier: String = ""
    public var state: ToDoFieldData = ToDoFieldData(text: "", isCompleted: false)
    
    private lazy var todoCheckbox: CustomCheckbox = {
       return CustomCheckbox()
    }()

    private lazy var todoTextField: CustomTextView = {
        return CustomTextView()
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
    
    public func configure(id: String, text: String, isCompleted: Bool) {
        self.identifier = id
        self.state = ToDoFieldData(text: text, isCompleted: isCompleted)
        
        self.todoTextField.text = text
        self.todoCheckbox.isChecked = isCompleted
        
        self.checkBoxTapped()
    }
    
    init() {
        super.init(frame: .zero)
        
        setUpStackView()
    }
    
    private func setUpStackView() {
        self.addArrangedSubview(todoCheckbox)
        self.addArrangedSubview(todoTextField)
        self.addArrangedSubview(deleteButtonIcon)
        
        todoCheckbox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        // weak self prevent from memory leak and clouse the reference
        todoTextField.onTextChanged = { [weak self] text in
            guard let self = self else {return}
            self.state.text = text
        }
        
        setUpDefaultStyles()
        setUpConstraints()
    }
    
    @objc func checkBoxTapped() -> Void {
        deleteButtonIcon.tintColor = todoCheckbox.isChecked ? .gray : .systemBlue
        todoTextField.textColor = todoCheckbox.isChecked ? .gray : .black
        if(todoCheckbox.isChecked) {
            self.state.isCompleted = true
            todoCheckbox.backgroundColor = .gray
            todoCheckbox.layer.borderColor = UIColor.gray.cgColor
        } else {
            self.state.isCompleted = false
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
