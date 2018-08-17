//
//  UserInfoVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
class UserInfoVC: UIViewController ,UITableViewDataSource, UITableViewDelegate{

  
    var userID = ""
    var pageNo = 1
    var totalCount = 0
    
    // 存储 cell的数据
    var myDataArray = [MeCollectModel]()
    var userModel = User(){
        didSet{
            userIconImageV.kf.setImage(with: URL(string: self.userModel.photo))
            if userModel.verify == 0{
                vipImageV.isHidden = true
            }
            mainTitleLab.text = userModel.nickName
            subTitleLab.text = userModel.description
            numberLab.text = "\(userModel.fn)粉丝  |  \(totalCount)视频"
        }
    }
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var vipImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var numberLab: UILabel!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var concernBut: UIButton!
    @IBOutlet weak var otherBut: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent;
        setStatusBarBackgroundColor(color: UIColor.clear)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default;
         setStatusBarBackgroundColor(color: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIconImageV.layer.masksToBounds = true
        userIconImageV.layer.cornerRadius = 40;
        tableV.wf_registerCell(cell: UserTableCell.self)
        NetworkRequest(page: pageNo)

    }

    func NetworkRequest(page: Int) {
        ///获取用户信息接口
        
        let url = "http://api.klm123.com/user/getVideoList?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&pageNo=\(page)&pageSize=10&userId=\(userID)"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                self.totalCount = jsonData["data"]["pager"]["totalCount"].int!
                if let collectArray = jsonData["data"]["videos"].arrayObject{

                    self.myDataArray = collectArray.compactMap({ MeCollectModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.tableV.reloadData()
                }
                if let collectDict = jsonData["data"]["user"].dictionaryObject{
                    
                    self.userModel = User.deserialize(from: collectDict as Dictionary)!
                   
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
    @IBAction func OnPopClick() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
