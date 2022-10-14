import SwiftUI

extension Array where Element: UIColor {
    /// Gets a color that is a given percentage through an array of Colors.
    /// - Parameters:
    ///   - percentage: Double between 0.0 and 1.0
    /// - Returns: Color object
    func colorAt(percentage: Double) -> Color {
        guard percentage > 0 else { return Color(first ?? .clear) }
        guard percentage < 1 else { return Color(last ?? .clear) }

        let floatIndex = percentage * Double(count - 1)
        let leftIndex = Int(floatIndex.rounded(.down))
        let rightIndex = Int(floatIndex.rounded(.up))
        let defaultIndex = Int(floatIndex.rounded())

        let leftColor = self[leftIndex]
        let rightColor = self[rightIndex]
        let fallbackColor = self[defaultIndex]

        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) =
            (0, 0, 0, 0)
        guard leftColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        else { return Color(fallbackColor) }

        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) =
            (0, 0, 0, 0)
        guard rightColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        else { return Color(fallbackColor) }

        let subPercentage = floatIndex - Double(leftIndex)
        let uiColor = UIColor(
            red: CGFloat(r1 + (r2 - r1) * subPercentage),
            green: CGFloat(g1 + (g2 - g1) * subPercentage),
            blue: CGFloat(b1 + (b2 - b1) * subPercentage),
            alpha: CGFloat(a1 + (a2 - a1) * subPercentage)
        )
        return Color(uiColor)
    }
}
