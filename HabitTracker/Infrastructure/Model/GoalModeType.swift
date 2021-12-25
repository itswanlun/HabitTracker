import Foundation

enum GoalModeType: Int32 {
    case count
    case mins
    case ml
    
    var text: String {
        switch self {
        case .count:
            return "Count"
        case .mins:
            return "Mins"
        case .ml:
            return "ML"
        }
    }
    
    var unitText: String {
        switch self {
        case .count:
            return ""
        case .mins:
            return "mins"
        case .ml:
            return "ml"
        }
    }
}
