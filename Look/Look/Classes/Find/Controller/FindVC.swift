//
//  FindVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/7.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
class FindVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 存储 cell的数据
    var myDataArray = [MeCollectModel]()
    var setsArray = [[String:Any]]()
    
    var lastContentOffset: CGFloat = 0.0
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var keyLab: UILabel!
    @IBOutlet weak var serchView: UIView!
    @IBOutlet weak var tableV: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableV.wf_registerCell(cell: UserTableCell.self)
        topView.height = 40+65+(Kwidth-60)/5
        NetworkRequest(page: 1)
    }

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/discover/getList/v/4?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&lastId=0&pageNo=\(page)&pageSize=10"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                self.keyLab.text = jsonData["data"]["keyWords"].string
                
                if let collectArray = jsonData["data"]["videos"].arrayObject{
                    
                    self.myDataArray = collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
                if let collectDict = jsonData["data"].dictionaryObject{
                    
                    self.setsArray = collectDict["sets"] as! [[String : Any]]
                    
                    for (n, dict) in self.setsArray.enumerated(){
                        let titleLab:UILabel = self.view.viewWithTag(n+1) as! UILabel
                        titleLab.text = dict["name"] as? String
                        
                        let imageV:UIImageView = self.view.viewWithTag(n+11) as! UIImageView
                        imageV.kf.setImage(with: URL(string: dict["icon"]! as! String))
                        
                    }
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
    
//    //实现scrollView代理
//    - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    //全局变量记录滑动前的contentOffset
//    lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
//
//    //    lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
//    }
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y < lastContentOffset ){
//    //向上
//    NSLog(@"上滑");
//    } else if (scrollView.contentOffset.y > lastContentOffset ){
//    //向下
//    NSLog(@"下滑");
//    }

    //在拖动开始时调用（可能需要一些时间和/或移动距离）
    //将要开始拖拖，手指已经放在查看上并准备拖动的那一刻
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
//         printCtm(lastContentOffset)
    }

    //当滚动视图停止时调用
    //查看已经停止滚动
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        printCtm("\(scrollView.contentOffset.y)  \(topView.height)")
        if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y>topView.height{
            UIView.animate(withDuration: 0.5) {
                self.serchView.y = -44
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.serchView.y = 20
            }
        }
    }


}
