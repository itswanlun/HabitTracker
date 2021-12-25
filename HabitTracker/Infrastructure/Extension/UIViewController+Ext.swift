import Foundation
import UIKit

extension UIViewController {
    func showMessage(title: String? = nil, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func showCheckMessage(title: String? = nil, message: String? = nil, completionHandler: @escaping () -> Void) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            completionHandler()
        }))
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(controller, animated: true, completion: nil)
    }
}
