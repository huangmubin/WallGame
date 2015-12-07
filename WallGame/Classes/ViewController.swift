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
        setColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initGameWillAppear()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initGameDidAppear()
        kHeight = view.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func setColor() {
        //
        view.backgroundColor = kColor ? kBackgroundColorA : kBackgroundColorB
        
        // 
    }
    
    // MARK: 初始化
    
    /** 初始化游戏 */
    func initGameWillAppear() {
        initData()
        isAPlayer = data.AFirst
        initWallCountLabel()
        initStepsLabel()
        initButtons()
        initWallDirect()
    }
    
    func initGameDidAppear() {
        initChessWall()
        initPlayer()
        initGameTipView()
        updatePlayerControl()
    }
    
    // MARK: - Game Logic
    
    /** 重置游戏
        0. 初始化数据
        1. 设置游戏角色
    */
    func reSetGame() {
        data = Model()
        arcPlayer()
        updateStepsLabel()
        updateWallCountLabel()
        initChessWall()
        initPlayer()
        updatePlayerControl()
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
        if !checkGameEnd() {
            isAPlayer = !isAPlayer
            updatePlayerControl()
        }
        data.saveData()
    }
    
    /** 根据游戏角色决定控件有效性 */
    func updatePlayerControl() {
        if isAPlayer {
            view.insertSubview(APlayer, aboveSubview: wallDirect)
            view.insertSubview(BPlayer, belowSubview: wallDirect)
        } else {
            view.insertSubview(BPlayer, aboveSubview: wallDirect)
            view.insertSubview(APlayer, belowSubview: wallDirect)
        }
        addPlayerWaitView()
    }
    
    /** 检查游戏是否已经结束 */
    func checkGameEnd() -> Bool {
        if data.APlayer.x == 8 {
            addGameEndView(true)
            return true
        } else if data.BPlayer.x == 0 {
            addGameEndView(false)
            return true
        } else {
            return false
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

    
    // MARK: - Game Controllers
    
    
    
    // MARK: Wall Count Label
    /** A木板数量标签 */
    @IBOutlet weak var AWallCountButton: UIButton!
    /** B木板数量标签 */
    @IBOutlet weak var BWallCountButton: UIButton!
    
    /** 初始化木板数量标签 */
    func initWallCountLabel() {
        updateWallCountLabel()
        
        AWallCountButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BWallCountButton.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    /** 更新模板数量标签 */
    func updateWallCountLabel() {
        AWallCountButton.setTitle("\(data.AWallCount)", forState: .Normal)
        BWallCountButton.setTitle("\(data.BWallCount)", forState: .Normal)
    }
    
    
    // MARK: Steps Label
    
    /** A剩余步数标签 */
    @IBOutlet weak var AStepsButton: UIButton!
    /** B剩余步数标签 */
    @IBOutlet weak var BStepsButton: UIButton!
    
    /** 初始化步数标签 */
    func initStepsLabel() {
        updateStepsLabel()
        
        AStepsButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BStepsButton.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    /** 更新步数标签 */
    func updateStepsLabel() {
        let walls = GameLogic.takeWallsArr(data.walls)
        let aSteps = GameLogic.checkBackLine(walls, locate: data.APlayer, player: data.BPlayer)
        let bSteps = GameLogic.checkBackLine(walls, locate: data.BPlayer, player: data.APlayer)
        AStepsButton.setTitle("\(aSteps.count)", forState: .Normal)
        BStepsButton.setTitle("\(bSteps.count)", forState: .Normal)
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
    
    
    // MARK: - Game Tip View
    
    @IBOutlet weak var APlayerBackGroundView: BackGround!
    
    @IBOutlet weak var AGameTipView: BackGround!
    @IBOutlet weak var BGameTipView: BackGround!
    
    @IBOutlet weak var AGameTipImage: UIImageView!
    @IBOutlet weak var BGameTipImage: UIImageView!
    
    @IBOutlet weak var AGameTipViewLeading: NSLayoutConstraint!
    @IBOutlet weak var AGameTipViewHeight: NSLayoutConstraint!
    @IBOutlet weak var BGameTipViewTrailing: NSLayoutConstraint!
    
    /** 初始化游戏遮挡视图 */
    func initGameTipView() {
        AGameTipView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BGameTipView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI * 0.5))
    }
    
    /** 更新表情 */
    func updateGameTipImage(image: UIImageView, i: Int, j: Int) {
        let dis = i - j
        switch dis {
        case -100 ..< -10:
            image.image = UIImage(named: "Face30")
        case -10 ..< -5:
            image.image = UIImage(named: "Face20")
        case -5 ..< 0:
            image.image = UIImage(named: "Face10")
        case 0 ..< 2:
            image.image = UIImage(named: "Face40")
        case 2 ..< 5:
            image.image = UIImage(named: "Face50")
        default:
            image.image = UIImage(named: "Face60")
        }
    }
    
    /** 更新视图位置到玩家区域 */
    func updateGameTipView(iLayout: NSLayoutConstraint, jLayout: NSLayoutConstraint) {
        let offset = (APlayerBackGroundView.frame.height - APlayerBackGroundView.frame.width) / 2
        let height = APlayerBackGroundView.frame.height
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                jLayout.constant = -height
                iLayout.constant = -offset + 10
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    /** 添加视图到玩家区域 */
    func addPlayerWaitView() {
        let i = Int(AStepsButton.titleLabel!.text!)!
        let j = Int(BStepsButton.titleLabel!.text!)!
        // A玩家则弹出B的视图
        if isAPlayer {
            updateGameTipImage(BGameTipImage, i: i, j: j)
            updateGameTipView(BGameTipViewTrailing, jLayout: AGameTipViewLeading)
        } else {
            updateGameTipImage(AGameTipImage, i: j, j: i)
            updateGameTipView(AGameTipViewLeading, jLayout: BGameTipViewTrailing)
        }
    }
    
    // MARK: 游戏结束操作
    
    @IBAction func GameEndViewTapGesture(sender: UITapGestureRecognizer) {
        removeGameEndView()
    }
    
    func addGameEndView(player: Bool) {
        var draw = false
        let nextSteps = GameLogic.checkMoveScope(player ? data.BPlayer : data.APlayer, OPlayer: player ? data.APlayer : data.BPlayer, walls: data.walls)
        let finish = player ? 0 : 8
        for step in nextSteps {
            if step.x == finish {
                draw = true
                break
            }
        }
        if draw {
            AGameTipImage.image = UIImage(named: "Face50")
            BGameTipImage.image = UIImage(named: "Face50")
        } else {
            AGameTipImage.image = player ? UIImage(named: "Face60") : UIImage(named: "Face30")
            BGameTipImage.image = player ? UIImage(named: "Face30") : UIImage(named: "Face60")
        }
        
        let height = APlayerBackGroundView.frame.height
        let width = (view.bounds.width/2) - APlayerBackGroundView.frame.width - 15
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.AGameTipViewLeading.constant = -height
                self.BGameTipViewTrailing.constant = -height
                self.view.layoutIfNeeded()
            }) { (finish) -> Void in
                self.AGameTipViewHeight.constant = width
                self.view.layoutIfNeeded()
                let offset = (self.AGameTipView.frame.height - self.AGameTipView.frame.width) / 2
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                    self.AGameTipViewLeading.constant =  -offset + 10
                    self.BGameTipViewTrailing.constant =  -offset + 10
                    self.view.layoutIfNeeded()
                    }, completion: { (finish) -> Void in
                        print("\(self.AGameTipView.frame)  \(self.view.frame)")
                        self.AGameTipView.userInteractionEnabled = true
                        self.BGameTipView.userInteractionEnabled = true
                })
        }
    }
    
    func removeGameEndView() {
        let height = APlayerBackGroundView.frame.height
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.AGameTipViewLeading.constant = -height
            self.BGameTipViewTrailing.constant = -height
            }) { (finish) -> Void in
                self.AGameTipViewHeight.constant = 0
                self.AGameTipView.userInteractionEnabled = false
                self.BGameTipView.userInteractionEnabled = false
                self.reSetGame()
        }
    }
}
