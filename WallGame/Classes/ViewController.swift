import UIKit

class ViewController: UIViewController, PlayerDelegate, WallDirectDelegate {

    // MARK: - Life Cycle
    
    /*
    0.计算尺寸
    1.第一次启动初始化初始模式数据
    2.初始化游戏
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        kSetDefaultDatas()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initGameWillAppear()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initGameDidAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: 初始化
    
    /** 初始化游戏 */
    func initGameWillAppear() {
        initData()
        isAPlayer = data.AFirst
        updatePlayerControl()
        initWallCountLabel()
        initStepsLabel()
        initButtons()
        initWallDirect()
    }
    
    func initGameDidAppear() {
        initChessWall()
        initPlayer()
    }
    
    // MARK: - Game Logic
    
    /** 重置游戏
        0. 初始化数据
        1. 设置游戏角色
    */
    func reSetGame() {
        data = Model()
        arcPlayer()
    }
    
    /** 变更游戏角色
     0. 判断是木板还是步数。更改数据。
     1. 更新步数标签。
     2. 记录棋谱。
     3. 查看游戏是否结束。
     4. 变更当前下子角色。
     */
    func changePlayer(step: SubModel) {
        if step.t {
            addWall(step)
            if isAPlayer {
                data.AWallCount--
            } else {
                data.BWallCount--
            }
            updateWallCountLabel()
            data.steps.append(step.copyMode())
        } else {
            if step.h {
                data.steps.append(data.APlayer.copyMode())
                data.APlayer.copyData(step)
            } else {
                data.steps.append(data.BPlayer.copyMode())
                data.BPlayer.copyData(step)
            }
        }
        updateStepsLabel()
        checkGameEnd()
        isAPlayer = !isAPlayer
        data.saveData()
        updatePlayerControl()
    }
    
    /** 根据游戏角色决定控件有效性 */
    func updatePlayerControl() {
        ARestartButton.enabled = isAPlayer
        ARetractButton.enabled = isAPlayer
        BRestartButton.enabled = !isAPlayer
        BRetractButton.enabled = !isAPlayer
        if isAPlayer {
            view.insertSubview(APlayer, aboveSubview: wallDirect)
            view.insertSubview(BPlayer, belowSubview: wallDirect)
            AInView.backgroundColor = UIColor.blueColor()
            BInView.backgroundColor = UIColor.clearColor()
        } else {
            view.insertSubview(BPlayer, aboveSubview: wallDirect)
            view.insertSubview(APlayer, belowSubview: wallDirect)
            AInView.backgroundColor = UIColor.clearColor()
            BInView.backgroundColor = UIColor.blueColor()
        }
    }
    
    /** 检查游戏是否已经结束 */
    func checkGameEnd() {
        if data.APlayer.x == 8 {
            print("游戏结束，A胜利")
        } else if data.BPlayer.x == 0 {
            print("游戏结束，B胜利")
        }
    }
    
    /** 游戏悔棋 */
    func retractGame() {
        if data.steps.count >= 2 {
            for _ in 0 ..< 2 {
                let step = data.steps.removeLast()
                if step.t {
                    if data.walls.last! == step {
                        data.walls.removeLast()
                        chessWall.datas = data.walls
                    }
                } else {
                    if step.h {
                        data.APlayer.copyData(step)
                        APlayer.move(data.APlayer)
                    } else {
                        data.BPlayer.copyData(step)
                        BPlayer.move(data.BPlayer)
                    }
                }
            }
        }
    }
    
    
    // MARK: Game Actions
    
    func arcPlayer() {
        let arc = arc4random() % 2
        isAPlayer = arc == 0
        data.AFirst = isAPlayer
        data.saveData()
        updatePlayerControl()
    }
    
    
    // MARK: - Datas
    
    /** 当前游戏玩家 */
    var isAPlayer: Bool = true
    
    /** GameData */
    var data: Model = Model()
    
    /** Initial Data */
    func initData() {
        data = Model.loadData()
    }
    
    // MARK: - Board
    
    /** Chessboard */
    @IBOutlet weak var chessboard: Chessboard!
    
    // MARK: - Game Controllers
    
    // MARK: Wall Count Label
    /** A木板数量标签 */
    @IBOutlet weak var AwallCountLabel: UILabel!
    /** B木板数量标签 */
    @IBOutlet weak var BwallCountLabel: UILabel!
    
    /** 初始化木板数量标签 */
    func initWallCountLabel() {
        updateStepsLabel()
        
        AwallCountLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BwallCountLabel.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    /** 更新模板数量标签 */
    func updateWallCountLabel() {
        AwallCountLabel.text = "Woods:\(data.AWallCount)"
        BwallCountLabel.text = "Woods:\(data.BWallCount)"
    }
    
    
    // MAKR: Steps Label
    
    /** A剩余步数标签 */
    @IBOutlet weak var AStepsLabel: UILabel!
    /** B剩余步数标签 */
    @IBOutlet weak var BStepsLabel: UILabel!
    
    
    /** 初始化步数标签 */
    func initStepsLabel() {
        updateStepsLabel()
        
        AStepsLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BStepsLabel.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    /** 更新步数标签 */
    func updateStepsLabel() {
        let walls = GameLogic.takeWallsArr(data.walls)
        let aSteps = GameLogic.checkBackLine(walls, locate: data.APlayer, player: data.BPlayer)
        let bSteps = GameLogic.checkBackLine(walls, locate: data.BPlayer, player: data.APlayer)
        AStepsLabel.text = "Steps:\(aSteps.count)"
        BStepsLabel.text = "Steps:\(bSteps.count)"
    }
    
    
    // MARK: Buttons
    
    @IBOutlet weak var ARetractButton: UIButton!
    @IBOutlet weak var ARestartButton: UIButton!
    
    @IBOutlet weak var BRestartButton: UIButton!
    @IBOutlet weak var BRetractButton: UIButton!
    
    /** 初始化按钮 */
    func initButtons() {
        ARetractButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        ARestartButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BRestartButton.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
        BRetractButton.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    /** 悔棋 */
    @IBAction func retractAction(sender: UIButton) {
        retractGame()
    }
    /** 重新开始 */
    @IBAction func restartAction(sender: UIButton) {
        reSetGame()
    }
    
    // MARK: Player View
    
    @IBOutlet weak var AInView: UIView!
    @IBOutlet weak var BInView: UIView!
    
    
    // MARK: - WallDirect
    
    @IBOutlet weak var wallDirect: WallDirect!
    
    func initWallDirect() {
        wallDirect.delegate = self
    }
    
    // MARK: WallDirectDelegate

    func wallDirectTouchEnded(wall: SubModel) {
        changePlayer(wall)
    }
    
    // MARK: - ChessWall
    
    /** ChessWallView */
    @IBOutlet weak var chessWall: ChessWall!
    
    /** initial Chess Wall */
    func initChessWall() {
        chessWall.datas = data.walls
    }
    
    /** 添加墙壁 */
    func addWall(wallModel: SubModel) {
        data.walls.append(wallModel)
        chessWall.datas.append(wallModel)
    }
    
    // MARK: - 棋子
    
    @IBOutlet weak var APlayer: Player!
    @IBOutlet weak var BPlayer: Player!
    
    // MARK: 棋子移动提示视图
    
    @IBOutlet weak var playerDirect: PlayerDirect!
    
    /** 初始化棋子 */
    func initPlayer() {
        APlayer.player = data.APlayer.h
        BPlayer.player = data.BPlayer.h
        APlayer.updateFrame(chessboard.frame, data: data.APlayer)
        BPlayer.updateFrame(chessboard.frame, data: data.BPlayer)
        APlayer.delegate = self
        BPlayer.delegate = self
        view.addSubview(APlayer)
        view.addSubview(BPlayer)
    }
    
    // MARK: PlayerDelegate
    
    /** 棋子开始移动。
        0. 判断移动的棋子。
        1. 获取可移动范围然后更新移动提示。
     */
    func playerTouchBegan(player: Bool) {
        let CPlayer = player ? data.APlayer : data.BPlayer
        let OPlayer = player ? data.BPlayer : data.APlayer
        playerDirect.datas = GameLogic.checkMoveScope(CPlayer, OPlayer: OPlayer, walls: data.walls)
    }
    
    /** 棋子移动结束。
     0. 检查是否取消移动。
     1. 正常移动则判断移动范围是否在合理范围。是的话更新数据。
     2. 根据数据移动棋子。
     3. 清理移动提示。
     */
    func playerTouchEnded(player: Bool, x: Int, y: Int) -> Bool {
        if x < 10 {
            let playerData = player ? data.APlayer : data.BPlayer
            let newData = SubModel(x: playerData.x + x, y: playerData.y + y, h: player, t: false)
            for dirct in playerDirect.datas {
                if dirct == newData {
                    changePlayer(newData)
                    if player {
                        APlayer.move(newData)
                    } else {
                        BPlayer.move(newData)
                    }
                    
                    playerDirect.datas = []
                    return false
                }
            }
        }
        
        playerDirect.datas = []
        return true
    }
}
