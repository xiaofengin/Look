//
//  VideoPlayerView.swift
//  Look
//
//  Created by 王峰 on 2018/8/21.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import BMPlayer
class VideoPlayerView: UIView, UITableViewDelegate, UITableViewDataSource ,NibLoadable{

    @IBOutlet weak var topTableValue: NSLayoutConstraint!
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var bottomCommentView: UIView!
    @IBOutlet weak var collectionLab: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var mainTitleHeight: NSLayoutConstraint!
    
    
    @IBOutlet var sectionView: UIView!
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var userTitleLab: UILabel!
    @IBOutlet weak var userSubtitleLab: UILabel!
    
    
    // 存储推荐视频的数据
    var myRecommendArray = [MeCollectModel]()
    // 存储评论视频的数据
    var myCommentArray = [ContentModel]()
    
    // 存储用户数据
    var userData = MeCollectModel()
    
    /// 播放器
    var player: BMPlayer?
    var rect:CGRect?
    
    // 存储评论视频cell高度
    var cellHeightArray = [CGFloat]()
    var userArray = [User]()
    var videoId = ""
    var pageNo = 1
    var block:(()->())?

    
    
    func viewDidLoadData() {
        tableV.alpha = 1
        tableV.wf_registerCell(cell: ConcernTableCell.self)
        tableV.wf_registerCell(cell: CommentTableCell.self)
        tableV.estimatedRowHeight = 0
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        topTableValue.constant = 360*Kwidth/640
        userIconImageV.layer.masksToBounds = true
        userIconImageV.layer.cornerRadius = 15.5
        
        BMPlayerManager.shared.topBarShowInCase = .always
        
        //        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        
        self.addSubview(player!)
        self.player?.snp.makeConstraints({
            $0.top.equalTo(self).offset((rect?.origin.y)!-64)
            $0.left.right.equalTo(self)
            $0.height.equalTo((rect?.size.height)!-50)
        })
        // 注意需要先执行一次更新约束
        self.layoutIfNeeded()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.player?.snp.makeConstraints({
                    $0.top.equalTo(self).offset(0)
                })
                self.layoutIfNeeded()
            }) { (isCompletion) in
                self.backgroundColor = UIColor.white.withAlphaComponent(1)
                //将view1挪到最下边
                self.sendSubview(toBack: self.player!)
            }
        }
        updateData(false)
    }
    
    func updateData(_ logo:Bool) {
        NetworkRequest(page: pageNo)
        ///视频详情
        let url = "http://api.klm123.com/video/getInfo?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&videoId=\(videoId)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                if let collectDict = jsonData["data"].dictionaryObject{
                    self.userData = MeCollectModel.deserialize(from: collectDict)!
                    
                    self.userIconImageV.kf.setImage(with: URL(string: self.userData.user.photo))
                    self.userTitleLab.text = self.userData.user.nickName
                    self.userSubtitleLab.text = "\(self.userData.user.fn.convertString())粉丝  \(self.userData.user.vn.convertString())视频"
                    
                    self.mainTitleLab.text = self.userData.title
                    self.subTitleLab.text = "\(self.userData.user.fn.convertString())次播放 \(self.userData.publishTime.convertString())发布"
                    self.collectionLab.text = self.userData.cn.convertString()
                   
                    if logo{
                        // 设置视频播放地址
                        self.player?.setVideo(resource: BMPlayerResource(url: URL(string: self.userData.streams[0].url)!))
                    }
                    
                }
                
            }
           
        })
        
        
        ///http://api.klm123.com/recommend/video/list?src=1000&t=1534669545.992945&pageNo=0&videoId=8307d8afd594
        ///推荐视频
        let url1 = "http://api.klm123.com/recommend/video/list?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&pageNo=0&videoId=\(videoId)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url1, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                if let collectArray = jsonData["data"]["videos"].arrayObject{
                    self.myRecommendArray = collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
            }
        })
    }
    func NetworkRequest(page: Int) {
        ///获取评论视频接口
        ///http://api.klm123.com/comment/getCommentList/v2?src=1000&t=1534669545.992945&lastId=0&pageNo=1&pageSize=10&videoId=8307d8afd594
        let url = "http://api.klm123.com/comment/getCommentList/v2?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&lastId=0&pageNo=\(page)&pageSize=10&videoId=\(videoId)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["comments"].arrayObject{
                    
                    self.myCommentArray += collectArray.compactMap({ ContentModel.deserialize(from: $0 as? Dictionary) })
                    
                    for (itemModel) in self.myCommentArray{
                        self.cellHeightArray.removeAll()
                        self.cellHeightArray.append(itemModel.content.textHeight(fontSize: 16.0, width: Kwidth-105)+85)
                    }
                    
                    self.tableV.reloadData()
                }
                
            }
        })
    }
    
    // 每组头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0.01
    }
    
    // 每组头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section==0 {
            return sectionView
        }
        return UIView()
    }
    // 每组尾部的高度
    func tableView(_ tableView: UITableView, heightForFooter section: Int) -> CGFloat {
        return 0.01
    }
    
    // 每组尾部视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return Kwidth*170/640
        }else{
            return cellHeightArray[indexPath.row]
        }
        
    }
    
    // 组数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // 每组的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myRecommendArray.count
        }
        return myCommentArray.count
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as ConcernTableCell
            cell.myConcern = myRecommendArray[indexPath.row]
            return cell
        }else{
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as CommentTableCell
            cell.model = myCommentArray[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let model = myRecommendArray[indexPath.row]
            videoId = model.videoId
            updateData(true)
        }
        
        
    }
    
    @IBAction func OnExpandClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            topView.height = 53 + (mainTitleLab.text?.textHeight(fontSize: 15, width: Kwidth-60))!
            mainTitleHeight.constant = (mainTitleLab.text?.textHeight(fontSize: 15, width: Kwidth-60))! + 3
            
        }else{
            topView.height = 70
            mainTitleHeight.constant = 20
        }
        
        tableV.reloadData()
    }
    
    @IBAction func OnAttentionClick() {
        
    }
    @IBAction func OnBlockClick() {
        
       
        
        tableV.alpha = 0
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        

        UIView.animate(withDuration: 0.5, animations: {
            self.y = (self.rect?.origin.y)!

        }) { (isCompletion) in

            self.removeFromSuperview()
            self.block?()
        }
      
    }
}





















