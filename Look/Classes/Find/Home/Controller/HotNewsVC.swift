//
//  HotNewsVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
//import FSPagerView
class HotNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var topView: UIView!
    var pageNo = 1
    var isLoad = true
    
    var hotNewsArray = [HotNewsModel]()
    var cellHeightArray = [CGFloat]()
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.height = 360*Kwidth/640
        tableV.wf_registerCell(cell: HotTable1Cell.self)
        tableV.wf_registerCell(cell: HotTable2Cell.self)
        
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
        
        let url = "http://api.klm123.com/channel/getHotChannelList/v/2?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&isLock=1&lastId=0&pageNo=\(page)&pageSize=10&rc=42"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    self.hotNewsArray = collectArray.compactMap({ HotNewsModel.deserialize(from: $0 as? Dictionary) })
                    
                    for item in self.hotNewsArray{
                        
                        if item.showType == 1{
                            let titleHight = item.video.title.textHeight(fontSize: 16, width: Kwidth-30-192*Kwidth/640)
                            if titleHight < 126*Kwidth/650{
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
    
}
