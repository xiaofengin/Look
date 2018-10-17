//
//  HotNewsVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSPagerView
import Kingfisher
class HotNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,FSPagerViewDataSource,FSPagerViewDelegate {

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var topView: FSPagerView!{
        didSet {
            self.topView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.topView.itemSize = .zero
        }
    }
    fileprivate var imageNames = [[String:Any]]()
    var pageNo = 1
    var isLoad = true
    
    var hotNewsArray = [HotNewsModel]()
    var cellHeightArray = [CGFloat]()
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.height = 360*Kwidth/640
        tableV.wf_registerCell(cell: HotTable1Cell.self)
        tableV.wf_registerCell(cell: HotTable2Cell.self)
        tableV.estimatedRowHeight = 0
        tableV.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.pageNo += 1
            self.NetworkRequest(page: self.pageNo)
        })
        //http://api.klm123.com/channel/getHotChannelList/v/2?src=1000&t=1533977846.622566&isLock=1&lastId=0&pageNo=1&pageSize=10&rc=42
//        NetworkRequest(page: pageNo)
    }

    func hotNewsRequset()  {
        if isLoad {
            NetworkRequest(page: pageNo)
            isLoad = false
        }
    }
    func NetworkRequest(page: Int) {
        ///获取新闻信息接口
        
        let url = "http://api.klm123.com/channel/getHotChannelList/v/2?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&isLock=1&lastId=0&pageNo=\(page)&pageSize=10&rc=\(page)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            if self.tableV.mj_footer.isRefreshing{self.tableV.mj_footer.endRefreshing()}
            self.tableV.mj_footer.pullingPercent = 0.0
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let banners = jsonData["data"]["banners"].arrayObject{
                    self.imageNames = banners as! [[String : Any]]
                    
                    self.topView.reloadData()
                }
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    self.hotNewsArray += collectArray.compactMap({ HotNewsModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.cellHeightArray.removeAll()
                    for item in self.hotNewsArray{
                        
                        if item.showType == 1{
                            let titleHight = item.video.title.textHeight(fontSize: 16, width: Kwidth-30-192*Kwidth/640)
                            if titleHight < 40{
                                self.cellHeightArray.append(126*Kwidth/650+24.0 )
                            }else{
                                self.cellHeightArray.append(titleHight+30+24)
                            }
                        }else{
                            let titleHight = item.video.title.textHeight(fontSize: 16, width: Kwidth-20)
                            if titleHight < 40{
                                self.cellHeightArray.append(titleHight+(Kwidth-20)*33/60+60)
                            }else{
                                self.cellHeightArray.append(40+(Kwidth-20)*33/60+60)
                            }
                        }
                    }
                    self.tableV.reloadData()
                }
                
            }
        })
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightArray[indexPath.row]
    }
    
    // 每组的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotNewsArray.count
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = hotNewsArray[indexPath.row]
        if model.showType == 1 {
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as HotTable1Cell
            cell.hotNewsModel = model
            return cell
        }else{
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as HotTable2Cell
            cell.hotNewsModel = model
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
     //jumpUrl
        cell.imageView?.kf.setImage(with: URL(string: imageNames[index]["imageUrl"] as! String))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
//        cell.textLabel?.text = index.description+index.description
        return cell
    }
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//        self.pageControl.currentPage = index
        
        let vc = webVC()
        vc.jumpUrl = imageNames[index]["jumpUrl"] as! String
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        printCtm(index)
    }
}
