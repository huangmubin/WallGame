import UIKit

// MARK: - Operator

infix operator == { associativity none precedence 130 }
func == (left: SubModel, right: SubModel) -> Bool {
    return left.x == right.x && left.y == right.y
}
func != (left: SubModel, right: SubModel) -> Bool {
    return !(left == right)
}

postfix operator ++ {}
postfix operator -- {}
postfix operator >> {}
postfix operator << {}

postfix func ++ (inout model: SubModel) -> SubModel {
    model.y++
    return model
}
postfix func -- (inout model: SubModel) -> SubModel {
    model.y--
    return model
}
postfix func >> (inout model: SubModel) -> SubModel {
    model.x++
    return model
}
postfix func << (inout model: SubModel) -> SubModel {
    model.x--
    return model
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
    Model.saveData([Model()])
}

// MARK: - 全局变量


// MARK: 尺寸

// ------------------
/** 屏幕宽度（横屏） */
var kWidth: CGFloat!
/** 屏幕高度（横屏） */
var kHeight: CGFloat!

// ------------------
/** 棋盘尺寸 */
var kBoardFrame: CGRect!
/** 棋格大小 */
var kCellSize: CGSize!
/** 木板大小 */
var kWallSize: CGSize!

// ------------------
/** 棋子大小 */
var kManSize: CGSize!

// ------------------
/** 仓库A尺寸 */
var kStorageAFrame: CGRect!
/** 仓库B尺寸 */
var kStorageBFrame: CGRect!

/** 玩家A按钮尺寸 */
var kPlayerAFrame: CGRect!
/** 玩家B按钮尺寸 */
var kPlayerBFrame: CGRect!
/**  */
/**  */
/**  */

// MARK: 颜色

/** 背景颜色 */
let kBackgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)

/** 棋盘格子颜色 */
let kCellColor = UIColor(red: 36.0/255.0, green: 38.0/255.0, blue: 47.0/255.0, alpha: 1)
/** 棋谱格子阴影颜色 */
let kCellShadowColor = UIColor.whiteColor()

/** 墙壁颜色 */
let kWallColor = UIColor.brownColor()
/** 墙壁边缘颜色 */
let kWallBorderColor = UIColor.brownColor()

/** A棋子颜色 */
let kPlayerAColor = UIColor.blueColor()
/** B棋子颜色 */
let kPlayerBColor = UIColor.redColor()

/** 棋子指引颜色 */
let kPlayerDirectColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */
/**  */