import UIKit

// MARK: - Operator

infix operator == { associativity none precedence 130 }
func == (left: SubModel, right: SubModel) -> Bool {
    return left.x == right.x && left.y == right.y
}
func != (left: SubModel, right: SubModel) -> Bool {
    return !(left == right)
}

// MARK: - 初始化

/** 启动时调用，设置默认值。 */
func kSetDefaultDatas() {
    NSUserDefaults.standardUserDefaults().registerDefaults(["firstLaunch": true])
    let first = NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch")
    if first {
        firstLaunch()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstLaunch")
    }
}
// 初次启动，设置一个初始化数据作为默认值
private func firstLaunch() {
    let model = Model()
    model.saveData()
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Color")
}

// MARK: - 全局变量

/** 屏幕高度（横屏） */
var kHeight: CGFloat!

// MARK: 尺寸
//
//// ------------------
///** 屏幕宽度（横屏） */
//var kWidth: CGFloat!
///** 屏幕高度（横屏） */
//var kHeight: CGFloat!
//
//// ------------------
///** 棋盘尺寸 */
//var kBoardFrame: CGRect!
///** 棋格大小 */
//var kCellSize: CGSize!
///** 木板大小 */
//var kWallSize: CGSize!
//
//// ------------------
///** 棋子大小 */
//var kManSize: CGSize!
//
//// ------------------
///** 仓库A尺寸 */
//var kStorageAFrame: CGRect!
///** 仓库B尺寸 */
//var kStorageBFrame: CGRect!
//
///** 玩家A按钮尺寸 */
//var kPlayerAFrame: CGRect!
///** 玩家B按钮尺寸 */
//var kPlayerBFrame: CGRect!
///**  */
///**  */
///**  */

// MARK: 颜色

var kColor = NSUserDefaults.standardUserDefaults().boolForKey("Color") {
    didSet {
        NSUserDefaults.standardUserDefaults().setBool(kColor, forKey: "Color")
    }
}

/** 背景颜色 */
let kBackgroundColorA = UIColor(red: 186.0/255.0, green: 153.0/255.0, blue: 241.0/255.0, alpha: 1)
let kBackgroundColorB = UIColor(red: 109.0/255.0, green: 41.0/255.0, blue: 70.0/255.0, alpha: 1)

/** 边线颜色 */
let kLineColorA = UIColor.whiteColor()
let kLineColorB = UIColor.whiteColor()

/** 格子边线颜色 */
let kCellLineColorA = UIColor(red: 137.0/255.0, green: 223.0/255.0, blue: 241.0/255.0, alpha: 1)
let kCellLineColorB = UIColor(red: 103.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1)

/** 墙壁颜色 */
let kWallColorA = UIColor(red: 118.0/255.0, green: 255.0/255.0, blue: 208.0/255.0, alpha: 1)
let kWallColorB = UIColor(red: 124.0/255.0, green: 255.0/255.0, blue: 229.0/255.0, alpha: 1)

/** 棋谱格子阴影颜色 */
let kCellShadowColorA = UIColor.clearColor()
let kCellShadowColorB = UIColor.whiteColor()

/** 棋子颜色 */
let kPlayerAColorA = UIColor(red: 244.0/255.0, green: 165.0/255.0, blue: 35.0/255.0, alpha: 1)
let kPlayerBColorA = UIColor(red: 238.0/255.0, green: 142.0/255.0, blue: 154.0/255.0, alpha: 1)
/** 棋子颜色 */
let kPlayerAColorB = UIColor(red: 244.0/255.0, green: 165.0/255.0, blue: 35.0/255.0, alpha: 1)
let kPlayerBColorB = UIColor(red: 238.0/255.0, green: 142.0/255.0, blue: 154.0/255.0, alpha: 1)


/** 错误提示色 */
let kWrongColor = UIColor(red: 255.0/255.0, green: 124.0/255.0, blue: 184.0/255.0, alpha: 1)


//====================

/** 棋盘格子颜色 */
let kCellColor = UIColor(red: 36.0/255.0, green: 38.0/255.0, blue: 47.0/255.0, alpha: 1)
/** 棋谱格子阴影颜色 */
let kCellShadowColor = UIColor.whiteColor()

/** 墙壁边缘颜色 */
let kWallBorderColor = UIColor.brownColor()


/** 棋子指引颜色 */
let kPlayerDirectColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)


/** 墙壁指引颜色正常 */
let kWallDirectColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)

/** 墙壁指引颜色错误 */
let kWallDirectColorWrong = UIColor.redColor()

/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */