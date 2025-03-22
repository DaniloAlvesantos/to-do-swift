import UIKit

class CustomUIButton: UIButton {
    lazy var onHighlightChange: ((Bool)) -> Void = {highlightState in
        self.alpha = highlightState ? 0.7 : 1
    }
    
    override var isHighlighted: Bool {
        didSet {
            onHighlightChange(isHighlighted)
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        setUpDefaultStyle()
    }
    
    func setUpDefaultStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
