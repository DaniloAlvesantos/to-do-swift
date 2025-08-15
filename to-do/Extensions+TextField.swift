import Foundation
import UIKit

extension UITextField {
    func alignToCheckBox(_ checkbox: UIButton) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor),
            self.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor)
        ])
    }
}
