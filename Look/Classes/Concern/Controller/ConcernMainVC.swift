//
//  ConcernMainVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
class ConcernMainVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

     let disposeBag = DisposeBag()
    @IBOutlet weak var tableV: UITableView!
    var pageNo = 1
    // 存储 cell的数据
    var myDataArray = [[MeCollectModel]]()
    var userArray = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableV.wf_registerCell(cell: ConcernTableCell.self)
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        tableV.estimatedRowHeight = 0
        self.title = "关注"
        NetworkRequest(page: pageNo)
       
    }
    func NetworkRequest(page: Int) {
        ///获取关注信息接口
        let url = "http://api.klm123.com/fans/getFeedList?src=1000&t=" + (UserDefaults.standard.object(forKey: startTimeUD) as! String) + "&pageNo=\(page)&pageSize=10"
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    for itemDict:Dictionary in (collectArray as! [[String : Any]]){
                        var subModel = [MeCollectModel]()
                        
                        if let itemArray:Dictionary = itemDict["userVideo"] as? [String :Any]{
                            self.userArray.append(User.deserialize(from:  itemArray["user"] as? Dictionary)!)
                            if let itemdict:[[String :Any]] = itemArray["videos"] as? [[String :Any]] {
                                for dict in itemdict{
                                    subModel.append(MeCollectModel.deserialize(from: dict)!)
                                }
                            }
                        }
                        self.myDataArray.append(subModel)
                    }
                    self.tableV .reloadData()
                }
                
            }
        })
    }

    
    // 每组头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (Kwidth-24)*333/592+12+70
    }
    
    // 每组头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ConcernHeaderView.loadViewFromNib()
        view.headBut.rx.tap
            .subscribe(onNext: { [weak self] in
               printCtm(section)
                let vc = UserInfoVC()
                vc.hidesBottomBarWhenPushed = true
                vc.userID = "\(self?.userArray[section].id ?? 0)"
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        view.hederViedoBut.rx.tap
            .subscribe(onNext: { [weak self] in
                printCtm(section)
                let vc = VideoPlayerVC()
                vc.hidesBottomBarWhenPushed = true
                vc.videoId = (self?.myDataArray[section][0].videoId)!
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        view.myConcern = myDataArray[section][0]
        view.userData = userArray[section]
        
        return view
    }
    // 每组尾部的高度
    func tableView(_ tableView: UITableView, heightForFooter section: Int) -> CGFloat {
        return 12
    }
    
    // 每组尾部视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        return Kwidth*170/640
    }
    
    // 组数
    func numberOfSections(in tableView: UITableView) -> Int {
        return myDataArray.count
    }
    // 每组的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataArray[section].count - 1
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as ConcernTableCell
        cell.myConcern = myDataArray[indexPath.section][indexPath.row+1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let vc = VideoPlayerVC()
        vc.hidesBottomBarWhenPushed = true
        vc.videoId = (self.myDataArray[indexPath.section][indexPath.row+1].videoId)
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
}
