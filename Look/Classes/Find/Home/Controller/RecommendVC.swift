//
//  RecommendVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecommendVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    // 存储 cell的数据
    var myDataArray = [HotNewsModel]()
    
    
    @IBOutlet weak var tableV: UITableView!
    let pageNO = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableV.wf_registerCell(cell: UserTableCell.self)
        NetworkRequest(page: pageNO)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           ///http://api.klm123.com/channel/getListById/version/6?src=1000&t=1533996516.432155&channelId=42&pageNo=1&pageSize=10&rc=8
        
    }
    
 

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/channel/getListById/version/6?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&channelId=42&pageNo=\(page)&pageSize=10&rc=8"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    self.myDataArray = collectArray.compactMap({ HotNewsModel.deserialize(from: $0 as? Dictionary) })
                    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
 

}
