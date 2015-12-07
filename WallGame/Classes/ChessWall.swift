import UIKit

class ChessWall: UIView {

    var datas = [SubModel]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let cellSize = bounds.height / 11
        let distance = cellSize * 1.25
        
        
        if kColor {
            kWallColorA.setFill()
        } else {
            kWallColorB.setFill()
        }
        for data in datas {
            let x = distance * CGFloat(data.x) + cellSize + (data.h ? -cellSize : 0) - 2
            let y = distance * CGFloat(data.y) + cellSize + (data.h ? 0 : -cellSize) - 2
            let rect = CGRectMake(x, y, cellSize * (data.h ? 2.25 : 0.25) + 4, cellSize * (data.h ? 0.25 : 2.25) + 4)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 4)
            path.fill()
        }
    }

}
