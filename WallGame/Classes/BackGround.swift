import UIKit

class BackGround: UIView {
    override func drawRect(rect: CGRect) {
        layer.backgroundColor = kColor ? kBackgroundColorA.CGColor : kBackgroundColorB.CGColor
        layer.borderColor     = kColor ? kLineColorA.CGColor : kLineColorB.CGColor
        layer.borderWidth     = kHeight > 800 ? 4 : 2
        layer.cornerRadius    = kHeight > 800 ? 14 : 8
    }
}
