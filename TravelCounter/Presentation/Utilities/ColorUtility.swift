import UIKit

enum ColorUtility {
    // 訪問回数に応じた色を返す
    static func getColorForCount(_ count: Int) -> UIColor {
        switch count {
        case 0:
            return .systemGray5  // 未訪問
        case 1:
            return .systemYellow.withAlphaComponent(0.7)  // 1回
        case 2...3:
            return .systemGreen.withAlphaComponent(0.7)   // 2-3回
        case 4...5:
            return .systemBlue.withAlphaComponent(0.7)    // 4-5回
        default:
            return .systemRed.withAlphaComponent(0.7)     // 6回以上
        }
    }
} 