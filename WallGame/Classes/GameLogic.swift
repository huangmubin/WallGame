import UIKit

class GameLogic: NSObject {
    class func checkMoveScope(center: SubModel, OtherPlayer player: SubModel, walls: [String:SubModel]) -> [SubModel] {
        var scope = [SubModel]()
        
        // 判断单元格是不是会重叠
        func append(last: SubModel, wallStrs: [String], isH: Bool) {
            scope.append(last)
            if last.x < 0 || last.x > 8 || last.y < 0 || last.y > 8 {
                scope.removeLast()
            } else {
                for wallStr in wallStrs {
                    if let wall = walls[wallStr] {
                        if wall.h == isH {
                            scope.removeLast()
                        }
                    }
                }
            }
        }
        
        append(center.up(),    wallStrs: ["\(center.x)\(center.y-1)", "\(center.x-1)\(center.y-1)"], isH: true)
        append(center.down(),  wallStrs: ["\(center.x)\(center.y)",   "\(center.x-1)\(center.y)"], isH: true)
        append(center.left(),  wallStrs: ["\(center.x)\(center.y)",   "\(center.x)\(center.y-1)"], isH: false)
        append(center.right(), wallStrs: ["\(center.x-1)\(center.y)", "\(center.x-1)\(center.y-1)"], isH: false)
        
        // 判断重叠
        for (index, locate) in scope.enumerate() {
            if locate == player {
                scope.removeAtIndex(index)
                if locate.up() != center {
                    append(locate.up(), wallStrs: ["\(center.x)\(center.y-1)", "\(center.x-1)\(center.y-1)"], isH: true)
                }
                if locate.down() != center {
                    append(locate.down(), wallStrs: ["\(center.x)\(center.y)", "\(center.x-1)\(center.y)"], isH: true)
                }
                if locate.left() != center {
                    append(locate.left(), wallStrs: ["\(center.x)\(center.y)", "\(center.x)\(center.y-1)"], isH: false)
                }
                if locate.right() != center {
                    append(locate.right(), wallStrs: ["\(center.x-1)\(center.y)", "\(center.x-1)\(center.y-1)"], isH: false)
                }
            }
        }
        return scope
    }
    
    class func checkWallDirection(location: CGPoint, cellSize: CGFloat) -> Bool {
        let offset = (location.y + (cellSize * 0.125)) % (cellSize * 1.25)
        return !(offset < cellSize * 0.3125 || offset > cellSize * 0.9375)
    }
}
