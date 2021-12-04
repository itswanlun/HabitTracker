import UIKit

class ColorViewController: UIViewController {
    
    private let reuseIdentifier = "colorcell"
    private var colors: [UIColor] = [UIColor(rgb: 0xB4A582), UIColor(rgb: 0x69B0AC), UIColor(rgb: 0x86C166), UIColor(rgb: 0xD7B98E), UIColor(rgb: 0xC73E3A), UIColor(rgb: 0xD7C4BB), UIColor(rgb: 0xD0104C), UIColor(rgb: 0xE16B8C), UIColor(rgb: 0xFEDFE1), UIColor(rgb: 0xFEDFE1)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension ColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let color = colors[indexPath.row]
        cell.backgroundColor = color
        
        return cell
    }
}

extension ColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        
        let space: CGFloat = flowLayout.minimumInteritemSpacing
            + flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
        
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
