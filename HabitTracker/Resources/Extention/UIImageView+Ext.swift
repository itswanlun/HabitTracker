import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL) {
        // Call API
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            if let data2 = data1, let image = UIImage.init(data: data2) {
            if let data = data, let image = UIImage(data: data) {
                // GCD
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
