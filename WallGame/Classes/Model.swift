import UIKit

/** 游戏数据模型：墙壁数据，棋子数据，木板数据。 */
class Model: NSObject, NSCoding, NSCopying {
    
    // MARK: - 数据
    
    var APlayer:SubModel
    var BPlayer:SubModel
    
    var AWallCount:Int
    var BWallCount:Int
    
    var walls: [String:SubModel]
    
    // MARK: - 初始化
    
    override init() {
        APlayer = SubModel(x: 0, y: 4, h: true)
        BPlayer = SubModel(x: 8, y: 4, h: false)
        
        AWallCount = 10
        BWallCount = 10

        walls = [String:SubModel]()
    }
    required init?(coder aDecoder: NSCoder) {
        APlayer     = aDecoder.decodeObjectForKey("APlayer") as! SubModel
        BPlayer     = aDecoder.decodeObjectForKey("BPlayer") as! SubModel
        AWallCount  = aDecoder.decodeIntegerForKey("AWallCount")
        BWallCount  = aDecoder.decodeIntegerForKey("BWallCount")
        walls       = aDecoder.decodeObjectForKey("walls") as! [String:SubModel]
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(APlayer, forKey: "APlayer")
        aCoder.encodeObject(BPlayer, forKey: "BPlayer")
        aCoder.encodeInteger(AWallCount, forKey: "AWallCount")
        aCoder.encodeInteger(BWallCount, forKey: "BWallCount")
        aCoder.encodeObject(walls, forKey: "walls")
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Model()
        copy.APlayer = APlayer
        copy.BPlayer = BPlayer
        copy.AWallCount = AWallCount
        copy.BWallCount = BWallCount
        copy.walls = walls
        return copy
    }
    // MARK: - Action
    
    
    // MARK: - Save and Load
    
    class func saveData(models: [Model]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        for (index, object) in models.enumerate() {
            archiver.encodeObject(object, forKey: "\(index)")
        }
        archiver.finishEncoding()
        
        NSUserDefaults.standardUserDefaults().setInteger(models.count, forKey: "GameDataCount")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "GameData")
    }

    class func loadData() -> [Model] {
        let data = NSUserDefaults.standardUserDefaults().objectForKey("GameData") as! NSData
        let count = NSUserDefaults.standardUserDefaults().integerForKey("GameDataCount")
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        var object = [Model]()
        for i in 0 ..< count {
            object.append(unarchiver.decodeObjectForKey("\(i)") as! Model)
        }
        unarchiver.finishDecoding()
        return object
    }
}

class SubModel: NSObject, NSCoding, NSCopying {
    var x: Int
    var y: Int
    var h: Bool
    
    // MARK: - Init
    
    override init() {
        x = 0
        y = 0
        h = true
    }
    
    init(x: Int, y: Int, h: Bool) {
        self.x = x
        self.y = y
        self.h = h
    }
    
    required init?(coder aDecoder: NSCoder) {
        x = aDecoder.decodeIntegerForKey("x")
        y = aDecoder.decodeIntegerForKey("y")
        h = aDecoder.decodeBoolForKey("h")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(x, forKey: "x")
        aCoder.encodeInteger(y, forKey: "y")
        aCoder.encodeBool(h, forKey: "h")
    }
    
    // MARK: - Copy
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = SubModel()
        copy.x = x
        copy.y = y
        copy.h = h
        return copy
    }
    
    func copyMode() -> SubModel {
        return copy() as! SubModel
    }
    
    func left() -> SubModel {
        var copy = copyMode()
        return copy>>
    }
    func right() -> SubModel {
        var copy = copyMode()
        return copy<<
    }
    func up() -> SubModel {
        var copy = copyMode()
        return copy--
    }
    func down() -> SubModel {
        var copy = copyMode()
        return copy++
    }
    
    // MARK: - Description
    
    override var description: String {
        return "x = \(x), y = \(y), h = \(h), Address = \(super.description)"
    }
    
//    deinit {
//        print("deint \(self)")
//    }
}