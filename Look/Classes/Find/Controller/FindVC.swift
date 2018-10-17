//
//  FindVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/7.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import RxSwift
import RxCocoa
import BMPlayer
class FindVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 存储 cell的数据
    var myDataArray = [MeCollectModel]()
    var setsArray = [[String:Any]]()
    
    var lastContentOffset: CGFloat = 0.0
    
    var pageNo = 1
    
    /// 懒加载 头部
    private lazy var videoPlayerV = VideoPlayerView.loadViewFromNib()
    private lazy var disposeBag = DisposeBag()
    /// 上一次播放的 cell
    private var priorCell: UserTableCell?
    /// 播放器
    lazy var player: BMPlayer = BMPlayer(customControlView: VideoPlayerCustomView())
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var keyLab: UILabel!
    @IBOutlet weak var serchView: UIView!
    @IBOutlet weak var tableV: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        removePlayer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableV.wf_registerCell(cell: UserTableCell.self)
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        tableV.estimatedRowHeight = 0
        topView.height = 40+65+(Kwidth-60)/5
        NetworkRequest(page: pageNo)
    }

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/discover/getList/v/4?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&lastId=0&pageNo=\(page)&pageSize=10"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                self.keyLab.text = jsonData["data"]["keyWords"].string
                
                if let collectArray = jsonData["data"]["videos"].arrayObject{
                    
                    self.myDataArray += collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
                if let collectDict = jsonData["data"].dictionaryObject{
                    
                    self.setsArray = collectDict["sets"] as! [[String : Any]]
                    
                    for (n, dict) in self.setsArray.enumerated(){
                        let titleLab:UILabel = self.view.viewWithTag(n+1) as! UILabel
                        titleLab.text = dict["name"] as? String
                        
                        let imageV:UIImageView = self.view.viewWithTag(n+11) as! UIImageView
                        imageV.kf.setImage(with: URL(string: dict["icon"]! as! String))
                        
                    }
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
            
        }).disposed(by: disposeBag)
        
        
        cell.userBut.rx.tap.subscribe(onNext: { [weak self] in
            let vc = UserInfoVC()
            vc.hidesBottomBarWhenPushed = true
            vc.userID = "\(cell.myConcern.user.id)"
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //在拖动开始时调用（可能需要一些时间和/或移动距离）
    //将要开始拖拖，手指已经放在查看上并准备拖动的那一刻
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
//         printCtm(lastContentOffset)
    }

    //当滚动视图停止时调用
    //查看已经停止滚动
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        printCtm("\(scrollView.contentOffset.y)  \(topView.height)")
        if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y>topView.height{
            UIView.animate(withDuration: 0.5) {
                self.serchView.y = -44
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.serchView.y = 20
            }
        }
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
    
    @IBAction func OnTitleButClick(_ sender: UIButton) {
        let vc = MoreSubVC()
        vc.channelId = "\(setsArray[sender.tag-21]["id"] ?? 0)"
        vc.hidesBottomBarWhenPushed = true
        vc.MoreSubRequset()
        vc.title = (setsArray[sender.tag-21]["name"] as! String)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func OnSerchClick() {
    }
    
}
extension FindVC{
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
