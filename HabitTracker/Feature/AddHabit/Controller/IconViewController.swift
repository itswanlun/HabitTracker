import UIKit

class IconViewController: UIViewController {
    private let reuseIdentifier = "iconcell"
    private var icons: [String] = ["🧘🏻", "💧", "🙏", "🍎", "🥦", "☕️","🏊🏻", "📚", "🍖","🥃", "🛏", "💩"]

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
}
