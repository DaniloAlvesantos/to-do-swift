import UIKit

class CustomCheckbox: UIButton {

    public var isChecked: Bool = false
    
    private lazy var checkMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setUpCheckbox()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCheckbox() {
        self.addSubview(checkMark)
        setDefaultStyle()
        setConstraints()
        
        self.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
    }
    
    func setDefaultStyle() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        backgroundColor = .clear
    }
    
    @objc func handleCheck() -> Void {
        self.isChecked = !isChecked
        self.checkMark.isHidden = !self.isChecked
        self.backgroundColor = self.isChecked ? .systemBlue : .clear
    }
    
    func getCheckState() -> Bool {
        return self.isChecked
    }
    
    func setConstraints() -> Void {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 20),
            self.heightAnchor.constraint(equalToConstant: 20),
            checkMark.widthAnchor.constraint(equalToConstant: 15),
            checkMark.heightAnchor.constraint(equalToConstant: 15),
            checkMark.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkMark.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
