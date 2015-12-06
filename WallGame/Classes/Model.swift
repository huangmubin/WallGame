import Foundation

/** 游戏数据模型：墙壁数据，棋子数据，木板数据，棋谱。 */
class Model: NSObject, NSCoding, NSCopying {
    
    // MARK: - 数据
    
    /** A方先开局 */
    var AFirst: Bool
    
    /** A方棋子 */
    var APlayer:SubModel
    /** B方棋子 */
    var BPlayer:SubModel
    
    /** A方木板数量 */
    var AWallCount:Int
    /** B方木板数量 */
    var BWallCount:Int
    
    /** 墙壁数据 */
    var walls: [SubModel]
    
    /** 棋谱数据 */
    var steps: [SubModel]
    
    // MARK: - 初始化
    
    override init() {
        AFirst = true
        
        APlayer = SubModel(x: 0, y: 4, h: true, t: false)
        BPlayer = SubModel(x: 8, y: 4, h: false, t: false)
        
        AWallCount = 10
        BWallCount = 10
        
        walls = [SubModel]()
        
        steps = [SubModel]()
    }
    required init?(coder aDecoder: NSCoder) {
        AFirst      = aDecoder.decodeBoolForKey("AFirst")
        APlayer     = aDecoder.decodeObjectForKey("APlayer") as! SubModel
        BPlayer     = aDecoder.decodeObjectForKey("BPlayer") as! SubModel
        AWallCount  = aDecoder.decodeIntegerForKey("AWallCount")
        BWallCount  = aDecoder.decodeIntegerForKey("BWallCount")
        walls       = aDecoder.decodeObjectForKey("walls") as! [SubModel]
        steps       = aDecoder.decodeObjectForKey("steps") as! [SubModel]
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(AFirst, forKey: "AFirst")
        aCoder.encodeObject(APlayer, forKey: "APlayer")
        aCoder.encodeObject(BPlayer, forKey: "BPlayer")
        aCoder.encodeInteger(AWallCount, forKey: "AWallCount")
        aCoder.encodeInteger(BWallCount, forKey: "BWallCount")
        aCoder.encodeObject(walls, forKey: "walls")
        aCoder.encodeObject(steps, forKey: "steps")
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Model()
        copy.AFirst = AFirst
        copy.APlayer = APlayer
        copy.BPlayer = BPlayer
        copy.AWallCount = AWallCount
        copy.BWallCount = BWallCount
        copy.walls = walls
        copy.steps = steps
        return copy
    }
    // MARK: - Action
    
    
    // MARK: - Save and Load
    
    /** 永久保存棋谱和开局 */
    func saveData() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(steps)
        NSUserDefaults.standardUserDefaults().setBool(AFirst, forKey: "AFirst")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "GameData")
    }
    
    /** 读取棋谱和开局，并还原数据 */
    class func loadData() -> Model {
        let data = NSUserDefaults.standardUserDefaults().objectForKey("GameData") as! NSData
        let AFirst = NSUserDefaults.standardUserDefaults().boolForKey("AFirst")
        let steps = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [SubModel]
        return review(AFirst, steps: steps)
    }
    
    /** 根据棋谱记录，还原Model */
    class func review(AFirst: Bool, steps: [SubModel]) -> Model {
        let data = Model()
        var to = AFirst
        
        // 循环步数
        for step in steps {
            // 如果是木板则添加木板到字典中，并减少相应人员的木板数量
            // 棋子则移动棋子
            if step.t {
                if to {
                    data.AWallCount--
                } else {
                    data.BWallCount--
                }
                data.walls.append(step)
            } else {
                if to {
                    data.APlayer.copyData(step)
                } else {
                    data.BPlayer.copyData(step)
                }
            }
            to = !to
        }
        return data
    }
    
}

class SubModel: NSObject, NSCoding, NSCopying {
    
    /** x轴坐标 */
    var x: Int
    /** y轴坐标 */
    var y: Int
    /** 如果是木板，则表示横向horizontal与竖向vertical。如果是棋子，则表示A与B。 */
    var h: Bool
    /** 类型，True表示木板，False表示棋子。 */
    var t: Bool
    // MARK: - Init
    
    override init() {
        x = 0
        y = 0
        h = true
        t = true
    }
    
    init(x: Int, y: Int, h: Bool, t: Bool) {
        self.x = x
        self.y = y
        self.h = h
        self.t = t
    }
    
    required init?(coder aDecoder: NSCoder) {
        x = aDecoder.decodeIntegerForKey("x")
        y = aDecoder.decodeIntegerForKey("y")
        h = aDecoder.decodeBoolForKey("h")
        t = aDecoder.decodeBoolForKey("t")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(x, forKey: "x")
        aCoder.encodeInteger(y, forKey: "y")
        aCoder.encodeBool(h, forKey: "h")
        aCoder.encodeBool(t, forKey: "t")
    }
    
    // MARK: - Copy
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = SubModel()
        copy.x = x
        copy.y = y
        copy.h = h
        copy.t = t
        return copy
    }
    
    /** 复制并建立新值 */
    func copyMode() -> SubModel {
        return copy() as! SubModel
    }
    
    /** 复制x,y两个属性*/
    func copyData(model: SubModel) {
        x = model.x
        y = model.y
    }
    
    /** 获取相邻方格 */
    func left() -> SubModel? {
        if x - 1 >= 0 {
            let copy = copyMode()
            copy.x--
            return copy
        } else {
            return nil
        }
    }
    /** 获取相邻方格 */
    func right() -> SubModel? {
        if x + 1 < 9 {
            let copy = copyMode()
            copy.x++
            return copy
        } else {
            return nil
        }
    }
    /** 获取相邻方格 */
    func up() -> SubModel? {
        if y - 1 >= 0 {
            let copy = copyMode()
            copy.y--
            return copy
        } else {
            return nil
        }
    }
    /** 获取相邻方格 */
    func down() -> SubModel? {
        if y + 1 < 9 {
            let copy = copyMode()
            copy.y++
            return copy
        } else {
            return nil
        }
    }
    
    // MARK: - Description
    
    override var description: String {
        return "x = \(x), y = \(y), h = \(h), t = \(t), Address = \(super.description)"
    }
    
    //    deinit {
    //        print("deint \(self)")
    //    }
}
