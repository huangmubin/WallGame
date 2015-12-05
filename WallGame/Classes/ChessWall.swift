import UIKit

class ChessWall: UIView {

    var datas = [String:SubModel]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let cellSize = bounds.height / 11
        let distance = cellSize * 1.25
        
        kWallColor.setFill()
        for data in datas.values {
            let x = distance * CGFloat(data.x) + cellSize + (data.h ? -cellSize : 0)
            let y = distance * CGFloat(data.y) + cellSize + (data.h ? 0 : -cellSize)
            let rect = CGRectMake(x, y, cellSize * (data.h ? 2.25 : 0.25), cellSize * (data.h ? 0.25 : 2.25))
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 4)
            path.fill()
        }
    }

}
