import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet var habitNameLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
