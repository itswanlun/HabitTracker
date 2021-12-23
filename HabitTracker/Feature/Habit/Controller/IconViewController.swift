import UIKit

protocol IconViewControllerDelegate: AnyObject {
    func Icon(_ viewController: IconViewController, receivedIcon icon: String)
}

class IconViewController: UIViewController {
    private let reuseIdentifier = "iconcell"
    private var icons: [String] = ["🧘🏻", "💧", "🙏", "🍎", "🥦", "☕️","🏊🏻", "📚", "🍖","🥃", "🛏", "💩"]
    weak var delegate: IconViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: 0xBFAE9F)

        // Do any additional setup after loading the view.
    }
    

}

extension IconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell

        let icon = icons[indexPath.row]
        cell.iconLabel.text = icon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        delegate?.Icon(self, receivedIcon: icons[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
