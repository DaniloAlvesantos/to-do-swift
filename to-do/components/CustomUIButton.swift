import UIKit

class CustomUIButton: UIButton {
    private var icon: UIImage?
    
    lazy var onHighlightChange: ((Bool)) -> Void = {highlightState in
        self.alpha = highlightState ? 0.7 : 1
    }
    
    override var isHighlighted: Bool {
        didSet {
            onHighlightChange(isHighlighted)
        }
    }
    
    init(title: String, icon: UIImage? = nil) {
        super.init(frame: .zero)
        
        if icon != nil {
            self.icon = icon
            setUpIcon()
        }
        
        self.setTitle(title, for: .normal)
        
        setUpDefaultStyle()
    }
    
    private func setUpIcon() {
        var config = UIButton.Configuration.filled()
            
        config.image = self.icon
        config.imagePlacement = .leading
        config.imagePadding = 10
        
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
            
        self.configuration = config
    }
    
    public func setUpDefaultStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
