//
//  EditHabitIconViewController.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/12/10.
//

import UIKit

protocol EditHabitIconViewControllerDelegate: AnyObject {
    func Icon(_ viewController: EditHabitIconViewController, receivedIcon icon: String)
}

class EditHabitIconViewController: UIViewController {
    
    private let reuseIdentifier = "edithabiticoncell"
    private var icons: [String] = ["🧘🏻", "💧", "🙏", "🍎", "🥦", "☕️","🏊🏻", "📚", "🍖","🥃", "🛏", "💩"]
    weak var delegate: EditHabitIconViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension EditHabitIconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditHabitIconCollectionViewCell

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
