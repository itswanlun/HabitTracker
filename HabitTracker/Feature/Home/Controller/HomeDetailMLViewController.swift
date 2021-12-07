import UIKit
import MKRingProgressView

class HomeDetailMLViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var ringProgressView: RingProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var quickoneButton: UIButton!
    @IBOutlet weak var quicktwoButton: UIButton!
    @IBOutlet weak var quickthreeButton: UIButton!
    @IBOutlet weak var quickfourButton: UIButton!
    
    var item: Record?

    // MARK: - IBAction
    @IBAction func returnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func quickoneTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func quicktwoTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func quickthreeTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func quickfourTapped(_ sender: UIButton) {
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ringProgressView.ringWidth = 20
        //ringProgressView.progress = 0.5
        ringProgressView.startColor = UIColor(rgb: 0x535953)
        ringProgressView.endColor = UIColor(rgb: 0x535953)
    }
}

// MARK: - Setup UI
extension HomeDetailMLViewController {
    private func setupUI() {
        if let value = item?.value,
           let goal = item?.habit.goal {
            progressLabel.text = "\(value)" + " / " + "\(goal)"
            ringProgressView.progress = Double(Float(value)/Float(goal))
        } else {
            progressLabel.text = "0 / 0"
            ringProgressView.progress = 0.0
        }
        
        if let quickone = item?.habit.quickAdd1,
           let quicktwo = item?.habit.quickAdd2,
           let quickthree = item?.habit.quickAdd3,
           let quickfour = item?.habit.quickAdd4 {
            quickoneButton.setTitle("\(quickone)", for: .normal)
            quicktwoButton.setTitle("\(quicktwo)", for: .normal)
            quickthreeButton.setTitle("\(quickthree)", for: .normal)
            quickfourButton.setTitle("\(quickfour)", for: .normal)
        }
    }
}
