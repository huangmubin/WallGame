import UIKit

protocol PlayerDelegate: NSObjectProtocol {
    func playerTouchBegan(player: Bool)
    func playerTouchEnded(player: Bool, x: Int, y: Int) -> Bool
}

class Player: UIView {

    // MARK: - 游戏方判定
    
    /** true为A，false为B */
    var player: Bool = true
    
    // MARK: - 初始化视图内容
    
    var cellSize: CGFloat = 0
    var distance: CGFloat = 0
    var origin:   CGPoint = CGPointZero
    
    /** 根据棋子数据和棋盘大小更新视图内容。同时更新动画属性。 */
    func updateFrame(board: CGRect, data: SubModel) {
        cellSize = board.height / 11
        distance = cellSize * 1.25
        origin   = board.origin
        
        let x = CGFloat(data.x) * distance + origin.x + cellSize * 0.1
        let y = CGFloat(data.y) * distance + origin.y + cellSize * 0.1
        
        let size = cellSize * 0.8
        
        frame = CGRect(x: x, y: y, width: size, height: size)
        self.setNeedsDisplay()
    }
    
    // MARK: - Draw Rect
    
    override func drawRect(rect: CGRect) {
        layer.cornerRadius    = bounds.height / 2
        layer.backgroundColor = player ? kPlayerAColor.CGColor : kPlayerBColor.CGColor
    }

    // MARK: - 触摸事件
    
    var delegate: PlayerDelegate?
    var location: CGPoint!
    var oldOrigin: CGPoint!
    
    /** 触碰开始，记录原始位置并进行位移，然后调用代理方法。 */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        location  = CGPoint(x: frame.midX, y: frame.midY)
        oldOrigin = CGPoint(x: self.frame.origin.x + (player ? self.cellSize : -self.cellSize), y: self.frame.origin.y)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                self.frame.origin.x = self.frame.origin.x + (self.player ? self.cellSize : -self.cellSize)
            }) { (finish) -> Void in
                self.delegate?.playerTouchBegan(self.player)
        }
    }
    
    /** 移动视图 */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let center = touch.locationInView(self.superview!)
            let offset = CGPoint(x: center.x-location.x, y: center.y-location.y)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                    self.frame.origin = CGPoint(x: self.oldOrigin.x+offset.x, y: self.oldOrigin.y+offset.y)
                }, completion: nil)
        }
    }
    
    /** 触摸取消，回归初始位置。 */
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                self.frame.origin = CGPoint(x: self.oldOrigin.x - (self.player ? self.cellSize : -self.cellSize), y: self.oldOrigin.y)
            }, completion: nil)
        delegate?.playerTouchEnded(player, x: 100, y: 100)
    }
    
    /** 触摸结束，计算位移坐标。并返回调用。由控制器决定要不要回归原位。 */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let start = CGPoint(x: oldOrigin.x - (player ? cellSize : -cellSize), y: oldOrigin.y)
        let end   = frame.origin
        
        let offset = CGPoint(x: end.x-start.x, y: end.y-start.y)
        let x      = lroundf(Float(offset.x / (cellSize * 1.125)))
        let y      = lroundf(Float(offset.y / (cellSize * 1.125)))
        
        if delegate!.playerTouchEnded(player, x: x, y: y) {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                self.frame.origin = CGPoint(x: self.oldOrigin.x - (self.player ? self.cellSize : -self.cellSize), y: self.oldOrigin.y)
                }, completion: nil)
        }
    }
    
    // MARK: - Action
    
    /** 根据给定的数据，移动到该坐标上。 */
    func move(data: SubModel) {
        let x = CGFloat(data.x) * distance + origin.x + cellSize * 0.1
        let y = CGFloat(data.y) * distance + origin.y + cellSize * 0.1
        
        let size = cellSize * 0.8
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.frame = CGRect(x: x, y: y, width: size, height: size)
            }, completion: nil)
    }
}
