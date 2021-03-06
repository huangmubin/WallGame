import UIKit

class PlayerDirect: UIView {

    var datas = [SubModel]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let cellSize = bounds.height / 11
        let distance = cellSize * 1.25
        
        if kColor {
            kCellLineColorA.setFill()
        } else {
            kCellLineColorB.setFill()
        }
        for data in datas {
            let x = CGFloat(data.x) * distance
            let y = CGFloat(data.y) * distance
            let path = UIBezierPath(roundedRect: CGRectMake(x, y, cellSize, cellSize), cornerRadius: 4)
            path.fill()
        }
    }
}
