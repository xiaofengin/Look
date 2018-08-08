//
//  MeCollectVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/4.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
class MeCollectVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableV: UITableView!
    
    
    var myCollectArray = [MeCollectModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的收藏"

        tableV.wf_registerCell(cell: MeCollectTableCell.self)
        ///获取用户收藏信息接口
        let url = "http://api.klm123.com/collection/getCollectionList?src=1000&t=" + (UserDefaults.standard.object(forKey: startTimeUD) as! String) + "&pageNo=1&pageSize=10"
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["videos"].arrayObject{
                    
                    self.myCollectArray = collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    self.tableV .reloadData()
                }
                
            }
        })


    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCollectArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
        let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as MeCollectTableCell
        cell.meCollectModel = myCollectArray[indexPath.row]

        return cell
     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }


}
