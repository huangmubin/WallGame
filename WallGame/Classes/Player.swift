import UIKit

protocol PlayerDelegate: NSObjectProtocol {
    func playerTouchBegan(moveData: SubModel)
    func playerTouchMoved(moveData: SubModel)
    func playerTouchEnded(moveData: SubModel)
    func playerTouchCancelled(moveData: SubModel)
}

class Player: UIView {

    // MARK: - Data
    
    var data = SubModel()
    
    // MARK: Animation Data
    
    var cellSize: CGFloat = 0
    var distance: CGFloat = 0
    var origin:   CGPoint = CGPointZero
    
    // MARK: - Update the init Frame
    
    func updateFrame(board: CGRect) {
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
        layer.backgroundColor = data.h ? kPlayerAColor.CGColor : kPlayerBColor.CGColor
    }

    // MARK: - Gesture
    
    var delegate: PlayerDelegate?
    var location: CGPoint!
    var oldOrigin: CGPoint!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        location  = CGPoint(x: frame.midX, y: frame.midY)
        oldOrigin = CGPoint(x: self.frame.origin.x + (self.data.h ? self.cellSize : -self.cellSize), y: self.frame.origin.y)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.frame.origin.x = self.frame.origin.x + (self.data.h ? self.cellSize : -self.cellSize)
            }) { (finish) -> Void in
                self.delegate?.playerTouchBegan(self.data)
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let center = touch.locationInView(self.superview!)
            let offset = CGPoint(x: center.x-location.x, y: center.y-location.y)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                    self.frame.origin = CGPoint(x: self.oldOrigin.x+offset.x, y: self.oldOrigin.y+offset.y)
                }) { (finish) -> Void in
                    self.delegate?.playerTouchMoved(self.data)
            }
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.frame.origin = CGPoint(x: self.oldOrigin.x - (self.data.h ? self.cellSize : -self.cellSize), y: self.oldOrigin.y)
            }) { (finish) -> Void in
                self.delegate?.playerTouchCancelled(self.data)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let start = CGPoint(x: self.oldOrigin.x - (self.data.h ? self.cellSize : -self.cellSize), y: self.oldOrigin.y)
        let end = frame.origin
        
        let offset = CGPoint(x: end.x-start.x, y: end.y-start.y)
        let x = lroundf(Float(offset.x / (cellSize * 1.125)))
        let y = lroundf(Float(offset.y / (cellSize * 1.125)))
        
        let moveData = SubModel(x: data.x+x, y: data.y+y, h: data.h)
        delegate?.playerTouchEnded(moveData)
    }
    
    // MARK: - Action
    
    func move() {
        let x = CGFloat(data.x) * distance + origin.x + cellSize * 0.1
        let y = CGFloat(data.y) * distance + origin.y + cellSize * 0.1
        
        let size = cellSize * 0.8
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.frame = CGRect(x: x, y: y, width: size, height: size)
            }, completion: nil)
    }
}
