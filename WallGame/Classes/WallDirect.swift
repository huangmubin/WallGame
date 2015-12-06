import UIKit

protocol WallDirectDelegate: NSObjectProtocol {
    var data: Model { get set }
    var isAPlayer: Bool { get set }
    func wallDirectTouchEnded(wall: SubModel)
}

class WallDirect: UIView {
    
    lazy var cellSize: CGFloat  = self.bounds.height / 11
    
    var data : [Int] = []
    
    var sublayer  : CALayer!
    var wallLayer : CALayer!
    
    var delegate : WallDirectDelegate?
    
    // MARK: - Touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1.计算数据
        data = GameLogic.takeWallsArr(delegate!.data.walls)
        // 0.添加图层
        let touch = touches.first!
        let locat = touch.locationInView(self)
        addSubLayer(locat)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 0. 获取当前指向的数据
        let touch = touches.first!
        let locat = touch.locationInView(self)
        moveSubLayer(locat)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 0. 获取当前指向的数据
        let touch = touches.first!
        let locat = touch.locationInView(self)
        if let wallModel = moveSubLayer(locat) {
            delegate?.wallDirectTouchEnded(wallModel)
        }
        
        removeSubLayer()
        data = []
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        removeSubLayer()
        data = []
    }
    
    // MARK: - Action
    
    /** 检查墙壁位置是不是合理 */
    func checkWallsIsAllow(wall: SubModel) -> Bool {
        // 1. 检查wall不重复
        if wall.x > 8 || wall.x < 0 || wall.y > 8 || wall.y < 0 {
            wallLayer.backgroundColor = kWallDirectColorWrong.CGColor
            return false
        } else {
            let walls = GameLogic.takeWallsArr([wall])
            var repeatW = false
            for wall in walls {
                if data.contains(wall) {
                    repeatW = true
                }
            }
            // wall不重复，检查路线可不可行
            if !repeatW {
                let path = GameLogic.checkBackLine(walls + data, locate: delegate!.data.APlayer, player: delegate!.data.APlayer)
                if path.count == 0 {
                    wallLayer.backgroundColor = kWallDirectColorWrong.CGColor
                    return false
                }
            } else {
                wallLayer.backgroundColor = kWallDirectColorWrong.CGColor
                return false
            }
        }
        wallLayer.backgroundColor = kWallColor.CGColor
        return true
    }
    
    // MARK: - Layer
    
    /** 添加一个正方形的子层，再在其中添加一个绘制好的墙壁层。然后放到视图中。 */
    func addSubLayer(location: CGPoint) {
        let x          = location.x + (delegate!.isAPlayer ? 0 : -cellSize * 2.25)
        sublayer       = CALayer()
        sublayer.frame = CGRect(x: x, y: location.y - (delegate!.isAPlayer ? cellSize*1.75 : cellSize*0.5), width: cellSize*2.25, height: cellSize*2.25)
        
        wallLayer                 = CALayer()
        wallLayer.frame           = CGRect(x: 0, y: cellSize, width: cellSize*2.25, height: cellSize*0.25)
        wallLayer.cornerRadius    = 4
        wallLayer.backgroundColor = kWallColor.CGColor
        
        sublayer.addSublayer(wallLayer)
        layer.addSublayer(sublayer)
    }
    
    /** 根据当前的位置移动视图 */
    func moveSubLayer(location: CGPoint) -> SubModel? {
        // 0.位移图层
        let direct = GameLogic.checkWallDirection(location, cellSize: cellSize)
        let locatX = location.x + (delegate!.isAPlayer ? 0 : -cellSize * 2.25)
        let rotate = direct ?  0 : CGFloat(M_PI)*0.5
        if delegate!.isAPlayer {
            let locatY = location.y - (direct ? cellSize*1.125 : cellSize*1.75)
            sublayer.frame.origin = CGPoint(x: locatX, y: locatY)
            sublayer.transform    = CATransform3DMakeRotation(rotate, 0, 0, 1)
        } else {
            let locatY = location.y - (direct ? cellSize*1.125 : cellSize*0.5)
            sublayer.frame.origin = CGPoint(x: locatX, y: locatY)
            sublayer.transform    = CATransform3DMakeRotation(rotate, 0, 0, 1)
        }
        
        // 1.计算位置
        var offsetX:CGFloat
        var offsetY:CGFloat
        
        if delegate!.isAPlayer {
            offsetX = location.x + cellSize * 1.625
            offsetY = location.y - (direct ? -cellSize * 0.5 : cellSize * 0.3125)
        } else {
            offsetX = location.x - cellSize * 0.625
            offsetY = location.y - (direct ? -cellSize * 0.5 : -cellSize * 0.8125)
        }
        
        let x = Int((offsetX - cellSize * 0.5) / (cellSize * 1.25) + 0.5) - 1
        let y = Int((offsetY - cellSize * 0.5) / (cellSize * 1.25) + 0.5) - 1
        
        let wallModel = SubModel(x: x, y: y, h: direct, t: true)
        
        if checkWallsIsAllow(wallModel) {
            return wallModel
        } else {
            return nil
        }
    }
    
    /** 移除子视图 */
    func removeSubLayer() {
        sublayer.removeFromSuperlayer()
        wallLayer.removeFromSuperlayer()
        sublayer  = nil
        wallLayer = nil
    }
}
