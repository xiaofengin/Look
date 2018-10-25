//
//  RecommendVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import BMPlayer
import RxSwift
import RxCocoa
class RecommendVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    // 存储 cell的数据
    var myDataArray = [HotNewsModel]()
    
    @IBOutlet weak var tableV: UITableView!
    var pageNo = 1
    
    /// 懒加载 头部
    private lazy var videoPlayerV = VideoPlayerView.loadViewFromNib()
    private lazy var disposeBag = DisposeBag()
    /// 上一次播放的 cell
    private var priorCell: UserTableCell?
    /// 播放器
    lazy var player: BMPlayer = BMPlayer(customControlView: VideoPlayerCustomView())
    /// 当前播放的时间
    private var currentTime: TimeInterval = 0

    
    
    func recommendRequset()  {
        // 设置当前 cell 的属性
        priorCell?.showSubviews()
        // 判断当前播放器是否正在播放
        if self.player.isPlaying {
            self.player.pause()
            self.player.removeFromSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    override func viewWillDisappear(_ animated: Bool) {
        removePlayer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        player.delegate = self
        tableV.wf_registerCell(cell: UserTableCell.self)
        tableV.estimatedRowHeight = 0
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        NetworkRequest(page: pageNo)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           ///http://api.klm123.com/channel/getListById/version/6?src=1000&t=1533996516.432155&channelId=42&pageNo=1&pageSize=10&rc=8
        
    }
    
 

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/channel/getListById/version/6?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&channelId=42&pageNo=\(page)&pageSize=10&rc=8"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    self.myDataArray += collectArray.compactMap({ HotNewsModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
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
        cell.myConcern = myDataArray[indexPath.row].video
        
        
        
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
        }).disposed(by: cell.disposeBag)
        
        cell.commentBut.rx.tap.subscribe(onNext: { [weak self] in
        
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
            
            let window = UIApplication.shared.keyWindow
            
            let rect = cell.convert(cell.bounds, to: window)
            printCtm(rect)
       

            
            self?.videoPlayerV.player = self?.player
            self?.videoPlayerV.rect = rect
            self?.videoPlayerV.videoId = cell.myConcern.videoId
            self?.videoPlayerV.frame = CGRect(x: 0, y: 0, width: Kwidth, height: Kheight)

            self?.navigationController?.navigationBar.barStyle = .black
            self?.videoPlayerV.block = {[weak self] in
                self?.removePlayer()
                self?.navigationController?.navigationBar.barStyle = .default
            }
            self?.videoPlayerV.viewDidLoadData()
            window?.addSubview((self?.videoPlayerV)!)
            self?.priorCell?.showSubviews()
            
        }).disposed(by: cell.disposeBag)
        
        
        cell.userBut.rx.tap.subscribe(onNext: { [weak self] in
            let vc = UserInfoVC()
            vc.hidesBottomBarWhenPushed = true
            vc.userID = "\(cell.myConcern.user.id)"
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
}
extension RecommendVC{
    /// 把播放器添加到 cell 上
    private func addPlayer(on cell: UserTableCell) {
        // 视频播放时隐藏 cell 的部分子视图
        cell.hiddenSubviews();
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
extension RecommendVC: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
}
