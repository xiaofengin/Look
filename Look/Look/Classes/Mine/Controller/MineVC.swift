//
//  MineVC.swift
//  News
//
//  Created by 王峰 on 2018/7/28.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit
import SwiftyJSON
class MineVC: BaseViewController {
  


    override func viewDidLoad() {
        super.viewDidLoad()


       
        
        let url = BASE_URL + "/user/tab/tabs/?"
        let params = ["device_id": ""]
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: true, params: params, success: { (dataDict) in
            
           
            
        }) { (error) in
            print(error)
        }
    }

    
}


