//
//  HomeUITableViewCell.swift
//  HabitTracker
//
//  Created by Bing Kuo on 2021/10/17.
//

import UIKit

class HomeUITableViewCell: UITableViewCell {
    
    @IBOutlet var IconImageView: UIImageView!
    @IBOutlet var HabitName: UILabel!
    @IBOutlet var Record: UILabel!
    @IBOutlet var Percent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
