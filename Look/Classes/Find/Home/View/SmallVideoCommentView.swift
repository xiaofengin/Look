//
//  SmallVideoCommentView.swift
//  Look
//
//  Created by 王峰 on 2018/8/24.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON

class SmallVideoCommentView: UIView ,UITableViewDataSource, UITableViewDelegate, NibLoadable{
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var commentLab: UILabel!
    @IBOutlet weak var topView: UIView!
    
    
    // 存储评论视频的数据
    var myCommentArray = [ContentModel]()
    // 存储评论视频cell高度
    var cellHeightArray = [CGFloat]()
    var videoId = ""
    var commentNumber = ""
    
    var page = 1
    
    func loadView() {
        tableV.wf_registerCell(cell: CommentTableCell.self)
        
//        topView.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 10)

    }
    func NetworkRequest(page: Int) {
        
        commentLab.text = "\(commentNumber)条评论"
        ///获取评论视频接口
        ///http://api.klm123.com/comment/getCommentList/v2?src=1000&t=1534669545.992945&lastId=0&pageNo=1&pageSize=10&videoId=8307d8afd594
        let url = "http://api.klm123.com/comment/getCommentList/v2?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&lastId=0&pageNo=\(page)&pageSize=10&videoId=\(videoId)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["comments"].arrayObject{
                    
                    self.myCommentArray = collectArray.compactMap({ ContentModel.deserialize(from: $0 as? Dictionary) })
                    
                    for (itemModel) in self.myCommentArray{
                        self.cellHeightArray.append(itemModel.content.textHeight(fontSize: 16.0, width: Kwidth-105)+85)
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
    
        return myCommentArray.count
    }
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as CommentTableCell
        cell.model = myCommentArray[indexPath.row]
        return cell
        
        
    }
    @IBAction func OnCloseClick(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.y = Kheight
        })
    }
    
}
