//
//  AddHabitViewController.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/11/21.
//

import UIKit

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var closeButtonItem: UIBarButtonItem!
    @IBAction func closeButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalModleButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

}
