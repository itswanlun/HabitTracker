import Foundation
import UIKit

extension UITextField {
    func setLeftPadding(_ spacing: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: spacing))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
