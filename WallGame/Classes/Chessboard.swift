import UIKit

class Chessboard: UIView {

    override func drawRect(rect: CGRect) {
        let cellSize = bounds.height / 11
        let distance = cellSize * 1.25
        
        if kColor {
            kCellLineColorA.setStroke()
            kBackgroundColorA.setFill()
        } else {
            kCellLineColorB.setStroke()
            kBackgroundColorB.setFill()
        }
        for x in 0 ..< 9 {
            for y in 0 ..< 9 {
                let x = CGFloat(x) * distance + 1
                let y = CGFloat(y) * distance + 1
                let path = UIBezierPath(roundedRect: CGRectMake(x, y, cellSize - 2, cellSize - 2), cornerRadius: 4)
                path.fill()
                path.stroke()
            }
        }
        
    }

}
