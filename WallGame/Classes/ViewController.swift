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
        initWallCountLabel()
        initWallDirect()
    }
    
    func initGameDidAppear() {
        initChessWall()
        initPlayer()
    }
    
    // MARK: - Datas
    
    /** GameData */
    var data: Model {
        return _gameData.last!
    }
    var _gameData: [Model]!
    
    /** Initial Data */
    func initData() {
        _gameData = Model.loadData()
    }
    
    // MARK: - Board
    
    /** Chessboard */
    @IBOutlet weak var chessboard: Chessboard!
    
    // MARK: - WallCountLabel
    
    /** A木板数量标签 */
    @IBOutlet weak var AwallCountLabel: UILabel!
    /** B木板数量标签 */
    @IBOutlet weak var BwallCountLabel: UILabel!
    
    /** 初始化木板数量标签 */
    func initWallCountLabel() {
        AwallCountLabel.text = "\(data.AWallCount)"
        BwallCountLabel.text = "\(data.BWallCount)"
        
        AwallCountLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        BwallCountLabel.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 0.5))
    }
    
    // MARK: - WallDirect
    
    @IBOutlet weak var wallDirect: WallDirect!
    
    func initWallDirect() {
        wallDirect.delegate = self
    }
    
    // MARK: WallDirectDelegate
    
    func wallDirectTouchBegan() -> [String : SubModel] {
        return data.walls
    }
    func wallDirectTouchEnded(wall: SubModel?) {
        
    }
    // MARK: - ChessWall
    
    /** ChessWallView */
    @IBOutlet weak var chessWall: ChessWall!
    
    /** initial Chess Wall */
    func initChessWall() {
        chessWall.datas = data.walls
    }
    
    // MARK: - Player Direct
    
    @IBOutlet weak var playerDirect: PlayerDirect!
    
    // MARK: - Player
    
    @IBOutlet weak var APlayer: Player!
    @IBOutlet weak var BPlayer: Player!
    
    /** initial Player */
    func initPlayer() {
        APlayer.data = data.APlayer
        BPlayer.data = data.BPlayer
        APlayer.updateFrame(chessboard.frame)
        BPlayer.updateFrame(chessboard.frame)
        APlayer.delegate = self
        BPlayer.delegate = self
        view.addSubview(APlayer)
        view.addSubview(BPlayer)
    }
    
    // MARK: - PlayerDelegate
    
    var dirct = [SubModel]()
    
    func playerTouchBegan(moveData: SubModel) {
        let player = moveData.h ? data.BPlayer : data.APlayer
        dirct = GameLogic.checkMoveScope(moveData, OtherPlayer: player, walls: data.walls)
        playerDirect.datas = dirct
    }
    func playerTouchMoved(moveData: SubModel) {

    }
    func playerTouchEnded(moveData: SubModel) {
        let player  = moveData.h ? APlayer : BPlayer
        for dir in dirct {
            if dir == moveData {
                player.data.x = moveData.x
                player.data.y = moveData.y
            }
        }
        player.move()
        playerDirect.datas = []
        dirct = []
    }
    func playerTouchCancelled(moveData: SubModel) {
        dirct = []
    }
    
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    /**  */
    
}
