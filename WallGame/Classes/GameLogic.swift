import UIKit

class GameLogic: NSObject {
    
    // MARK: - 棋子移动
    
    /** 检查可移动单元格 */
    class func checkMoveScope(CPlayer: SubModel, OPlayer: SubModel, walls: [SubModel]) -> [SubModel] {
        
        // 创建判断数组
        let wallsArr = takeWallsArr(walls)
        
        // 获取数据
        return takeScopes(CPlayer, OPlayer: OPlayer, walls: wallsArr, over: true)
    }
    
    /** 获取数据 */
    class func takeScopes(CPlayer: SubModel, OPlayer: SubModel, walls: [Int], over: Bool) -> [SubModel] {
        var scopes = [SubModel]()
        // 根据函数获取数据，如果数据重叠则回调
        for fun in takeFunc(CPlayer, walls: walls) {
            if let data = fun() {
                if data == OPlayer {
                    if over {
                        scopes += takeScopes(OPlayer, OPlayer: CPlayer, walls: walls, over: false)
                    }
                } else {
                    scopes.append(data)
                }
            }
        }
        return scopes
    }
    
    /** 获取可行数组 */
    class func takeFunc(player: SubModel, walls: [Int]) -> [() -> SubModel?] {
        // 计算中心点坐标
        let id = takeId(player.x, y: player.y, t: false)
        
        // 获取操作函数
        var funcs:[() -> SubModel?] = []
        if !walls.contains(id+1) { funcs.append(player.right) }
        if !walls.contains(id-1) { funcs.append(player.left) }
        if !walls.contains(id+17) { funcs.append(player.down) }
        if !walls.contains(id-17) { funcs.append(player.up) }
        
        return funcs
    }
    
    /** 计算墙壁坐标数组 */
    class func takeWallsArr(walls: [SubModel]) -> [Int] {
        var wallsArr = [Int]()
        for wall in walls {
            let id = takeId(wall.x, y: wall.y, t: true)
            wallsArr.append(id)
            wallsArr.append(id - (wall.h ? 1 : 17))
            wallsArr.append(id + (wall.h ? 1 : 17))
        }
        return wallsArr
    }
    
    /** 计算坐标id */
    class func takeId(x: Int, y: Int, t: Bool) -> Int {
        let c = x * 2 + (t ? 1 : 0)
        let r = y * 2 + (t ? 1 : 0)
        return r * 17 + c
    }
    
    // MARK: - 墙壁放置
    
    /** 根据触摸位置计算墙壁的方向 */
    class func checkWallDirection(location: CGPoint, cellSize: CGFloat) -> Bool {
        let offset = (location.y + (cellSize * 0.125)) % (cellSize * 1.25)
        return offset < cellSize * 0.3125 || offset > cellSize * 0.9375
    }
    
    // MARK: - 路径计算
    
    /** 计算最短路线 */
    class func checkBackLine(walls: [Int], locate: SubModel, player: SubModel) -> [Int] {
        // 计算初始节点
        let path = countPath(locate)
        // 计算终点
        var finish = [Int]()
        let col = locate.h ? 8 : 0
        for i in 0 ..< 9 {
            finish.append(i * 10 + col)
        }
        
        
        /** 存储已经便利过的数据 */
        var storage = [path: (data:locate, dist: 0, path: -1)]
        /** 存储最终结点 */
        var pathStorage = [Int]()
        /** 查询队列 */
        var queue = [Int]()
        
        // 获取初始数据
        let datas = takeScopes(locate, OPlayer: player, walls: walls, over: true)
        enQueue(&queue, storage: &storage, datas: datas, path: path)
        
        while queue.count != 0 {
            let point = queue.removeFirst()
            if finish.contains(point) {
                pathStorage = takePath(storage, path: point)
                break
            } else {
                let datas = takeScopes(reCountPaht(point), OPlayer: player, walls: walls, over: true)
                enQueue(&queue, storage: &storage, datas: datas, path: point)
            }
        }
        
        return pathStorage
    }
    
    /** 获取路径 */
    class func takePath(storage: [Int: (data:SubModel, dist: Int, path: Int)], path: Int) -> [Int] {
        var point = path
        var paths = [Int]()
        
        while point != -1 {
            paths.insert(point, atIndex: 0)
            point = storage[point]!.path
        }
        
        return paths
    }
    
    /** 将数据添加到队列和仓库中 */
    class func enQueue(inout queue: [Int], inout storage: [Int: (data:SubModel, dist: Int, path: Int)], datas: [SubModel], path: Int) {
        let dist = storage[path]!.dist + 1
        for data in datas {
            let dataPath = countPath(data)
            if storage[dataPath] == nil {
                storage[dataPath] = (data, dist, path)
                queue.append(dataPath)
            }
        }
    }
    /** 计算路径标签 */
    class func countPath(data:SubModel) -> Int {
        return data.y * 10 + data.x
    }
    /** 还原路径标签 */
    class func reCountPaht(path: Int) -> SubModel {
        let x = path % 10
        let y = path / 10
        return SubModel(x: x, y: y, h: true, t: false)
    }
}

