//
//  FindVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/7.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON

class FindVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 存储 cell的数据
    var myDataArray = [MeCollectModel]()
    var setsArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/discover/getList/v/4?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&lastId=0&pageNo=\(page)&pageSize=10"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                
                if let collectArray = jsonData["data"]["videos"].arrayObject{
                    
                    self.myDataArray = collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
                if let collectDict = jsonData["data"]["user"].dictionaryObject{
                    
                    self.setsArray = collectDict["sets"] as! [Any]
                    
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
    }

}
