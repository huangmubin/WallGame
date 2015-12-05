import UIKit

protocol WallDirectDelegate: NSObjectProtocol {
    func wallDirectTouchBegan() -> [String:SubModel]
    func wallDirectTouchEnded(wall: SubModel?)
}

class WallDirect: UIView {
    
    var isAPlayer: Bool = true
    var data:[String:SubModel]!
    var sublayer: CALayer!
    var delegate: WallDirectDelegate?
    lazy var cellSize: CGFloat  = self.bounds.height / 11
    
    // MARK: - Touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        data = delegate?.wallDirectTouchBegan()
        let touch = touches.first!
        let location = touch.locationInView(self)
        addSubLayer(location)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInView(self)
        moveSubLayer(location)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeSubLayer()
        data = nil
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        removeSubLayer()
        data = nil
    }
    
    // MARK: - Layer
    
    /** 添加一个正方形的子层，再在其中添加一个绘制好的墙壁层。然后放到视图中。 */
    func addSubLayer(location: CGPoint) {
        sublayer = CALayer()
        let x = location.x + (isAPlayer ? 0 : -cellSize * 2.25)
        sublayer.frame = CGRect(x: x, y: location.y-cellSize*1.75, width: cellSize*2.25, height: cellSize*2.25)
        let wallLayer = CALayer()
        wallLayer.frame = CGRect(x: 0, y: cellSize*1.125, width: cellSize*2.25, height: cellSize*0.25)
        wallLayer.cornerRadius = 4
        wallLayer.backgroundColor = kWallColor.CGColor
        sublayer.addSublayer(wallLayer)
        layer.addSublayer(sublayer)
    }
    
    /** 根据当前的位置移动视图 */
    func moveSubLayer(location: CGPoint) {
        let rota = GameLogic.checkWallDirection(location, cellSize: cellSize)
        let x = location.x + (isAPlayer ? 0 : -cellSize * 2.25)
        let y = location.y - (rota ? cellSize*1.75 : cellSize*1.25)
        sublayer.frame.origin = CGPoint(x: x, y: y)
        let rotation = rota ? CGFloat(M_PI)*0.5 : 0
        sublayer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
    }
    
    /** 移除子视图 */
    func removeSubLayer() {
        sublayer.removeFromSuperlayer()
        sublayer = nil
    }
}
