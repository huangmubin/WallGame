import UIKit

class Chessboard: UIView {

    override func drawRect(rect: CGRect) {
        let cellSize = bounds.height / 11
        let distance = cellSize * 1.25
        
        kCellColor.setFill()
        for x in 0 ..< 9 {
            for y in 0 ..< 9 {
                let x = CGFloat(x) * distance
                let y = CGFloat(y) * distance
                let path = UIBezierPath(roundedRect: CGRectMake(x, y, cellSize, cellSize), cornerRadius: 8)
                path.fill()
            }
        }
        
    }

}
