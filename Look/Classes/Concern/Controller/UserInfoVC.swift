//
//  UserInfoVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import BMPlayer
import RxSwift
import RxCocoa
class UserInfoVC: UIViewController ,UITableViewDataSource, UITableViewDelegate{

  
    var userID = ""
    var pageNo = 1
    var totalCount = 0
    private lazy var disposeBag = DisposeBag()
    /// 上一次播放的 cell
    private var priorCell: UserTableCell?
    /// 播放器
    lazy var player: BMPlayer = BMPlayer(customControlView: VideoPlayerCustomView())
    // 存储 cell的数据
    var myDataArray = [MeCollectModel]()
    var userModel = User(){
        didSet{
            userIconImageV.kf.setImage(with: URL(string: self.userModel.photo))
            if userModel.verify == 0{
                vipImageV.isHidden = true
            }
            mainTitleLab.text = userModel.nickName
            subTitleLab.text = userModel.description
            numberLab.text = "\(userModel.fn)粉丝  |  \(totalCount)视频"
        }
    }
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var vipImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var numberLab: UILabel!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var concernBut: UIButton!
    @IBOutlet weak var otherBut: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        UIApplication.shared.statusBarStyle = .lightContent;
//        setStatusBarBackgroundColor(color: UIColor.clear)
         self.navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        UIApplication.shared.statusBarStyle = .default;
//         setStatusBarBackgroundColor(color: UIColor.white)
         self.navigationController?.navigationBar.barStyle = .default
         removePlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIconImageV.layer.masksToBounds = true
        userIconImageV.layer.cornerRadius = 40;
        tableV.wf_registerCell(cell: UserTableCell.self)
        tableV.estimatedRowHeight = 0
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        NetworkRequest(page: pageNo)

    }

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/user/getVideoList?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&pageNo=\(page)&pageSize=10&userId=\(userID)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                self.totalCount = jsonData["data"]["pager"]["totalCount"].int!
                if let collectArray = jsonData["data"]["videos"].arrayObject{

                    self.myDataArray += collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
                if let collectDict = jsonData["data"]["user"].dictionaryObject{
                    
                    self.userModel = User.deserialize(from: collectDict as Dictionary)!
                   
                }
            }
        })
    }

    

    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Kwidth*360/640+50
    }

    // 每组的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataArray.count
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as UserTableCell
        cell.myConcern = myDataArray[indexPath.row]
        cell.usericonView.isHidden = true
        cell.timeLab.text = (cell.myConcern.publishTime/1000).convertString()
        
        cell.playerBut.rx.tap.subscribe(onNext: { [weak self] in
            // 如果有值，说明当前有正在播放的视频
            if let priorCell = self!.priorCell {
                if cell != priorCell {
                    // 设置当前 cell 的属性
                    priorCell.showSubviews()
                    // 判断当前播放器是否正在播放
                    if self!.player.isPlaying {
                        self!.player.pause()
                        self!.player.removeFromSuperview()
                    }
                    // 把播放器添加到 cell 上
                    self!.addPlayer(on: cell)
                }
            } else { // 说明是第一次点击 cell，直接添加播放器
                // 把播放器添加到 cell 上
                self!.addPlayer(on: cell)
            }
        }).disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        printCtm(offsetY)
        if offsetY > 150 {

            topView.isHidden = false;
            topView.alpha = (offsetY-150)/150
        }else{
            topView.isHidden = true;
        }
        
        // 说明有视频正在播放
        if player.isPlaying {
            let imageButton = player.superview
            let contentView = imageButton?.superview
            let cell = contentView?.superview as! UserTableCell
            let rect = tableV.convert(cell.frame, to: self.view)
            // 判断是否滑出屏幕
            if (rect.origin.y <= -cell.height) || (rect.origin.y >= Kheight - tabBarController!.tabBar.height) {
                removePlayer()
                // 设置当前 cell 的属性
                cell.showSubviews();
            }
        }
    }
    @IBAction func OnPopClick() {
        
        tableV.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension UserInfoVC{
    /// 把播放器添加到 cell 上
    private func addPlayer(on cell: UserTableCell) {
        // 视频播放时隐藏 cell 的部分子视图
        cell.hiddenSubviews();
        cell.attentionBut.isHidden = true
        cell.timeLab.isHidden = false
        cell.playerBut.addSubview(self.player);
        self.player.snp.makeConstraints({ $0.edges.equalTo(cell.playerBut) })
        
        // 设置视频播放地址
        self.player.setVideo(resource: BMPlayerResource(url: URL(string: cell.myConcern.streams[0].url)!))
        self.priorCell = cell
        
    }
    
    /// 移除播放器
    private func removePlayer() {
        player.pause()
        player.removeFromSuperview()
        priorCell = nil
    }
}
extension UserInfoVC: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {

    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
}
