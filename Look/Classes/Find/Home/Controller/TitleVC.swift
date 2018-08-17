//
//  TitleVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/13.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
class TitleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet var sectionHeaderView: UIView!
    
    var titleSelect:((_ butTag:Int, _ dataArray:[TitleModel])->())?
    
    var myDataArray = [TitleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableV.wf_registerCell(cell: TitleTableCell.self)
        
        NetworkRequest()
    }
    
    ///http://api.klm123.com/channel/getChannelList/v8?src=1000&t=1534171142.556522
    ///http://api.klm123.com/channel/getChannelList/v8?src=1000&t=1534209273.033551
    func NetworkRequest() {
        ///获取用户信息接口
        
//        let path = Bundle.main.path(forResource:"TitleJson", ofType: "geojson")
        
        // pilst 文件的路径
        let path = Bundle.main.path(forResource: "title", ofType: "plist")
        // plist 文件中的数据
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
        
        myDataArray = cellPlist.compactMap({ TitleModel.deserialize(from: $0 as? [String: Any]) })
        
        tableV.reloadData()
//        let url = "http://api.klm123.com/channel/getChannelList/v8?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))"
        
//        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
//
//            let jsonData = JSON(dataDict)
//            printCtm(jsonData)
//            if jsonData["code"] == 0{
//
//                if let collectArray = jsonData["data"]["channels"].arrayObject{
//
//                    self.myDataArray = collectArray.compactMap({ TitleModel.deserialize(from: $0 as? Dictionary) })
//
//                    self.myDataArray.remove(at: 0)
//                    self.myDataArray.remove(at: 0)
//                    self.myDataArray.remove(at: 0)
//                    self.tableV.reloadData()
//                }
//
//            }
//        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as TitleTableCell
        cell.model = myDataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        titleSelect?(indexPath.row, myDataArray)
        OnCloseClick()
    }
    @IBAction func OnCloseClick() {
        
        UIView.animate(withDuration: 0.3) {
            self.view.x = -Kwidth
        }
        
    }
    
}
