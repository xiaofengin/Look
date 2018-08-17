//
//  MineVC.swift
//  News
//
//  Created by 王峰 on 2018/7/28.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
class MineVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var userDescriptionLab: UILabel!
    @IBOutlet weak var tableV: UITableView!
    
    
    let dataArray = [["titleImage":"播放记录", "title":"播放记录"],
                    ["titleImage":"上传", "title":"我的上传"],
                    ["titleImage":"收藏", "title":"我的收藏"],
                    ["titleImage":"关注", "title":"我的关注"],
                    ["titleImage":"商城", "title":"金币商城"],
                    ["titleImage":"消息", "title":"我的消息"],
                    ["titleImage":"设置", "title":"设置"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        UIApplication.shared.statusBarStyle = .lightContent;
        setStatusBarBackgroundColor(color: UIColor.clear)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        UIApplication.shared.statusBarStyle = .default;
        setStatusBarBackgroundColor(color: UIColor.white)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableV.wf_registerCell(cell: MineTableCell.self)
        tableV.wf_registerCell(cell: PlayRecordTableCell.self)
        setStatusBarBackgroundColor(color: .white)

        if UserDefaults.standard.object(forKey: userUD) == nil{
            ///获取用户信息接口
            let url = "http://passport.klm123.com/login/loginByThirdparty?src=1000&t=" + (UserDefaults.standard.object(forKey: startTimeUD) as! String)
            let params = ["app": "2","openid": "oeN411c0dILrhE1AsxKI8Hx3ySFs","token": "12_UZIhBR3z_4nZ5fBD3eX1nFwR11Yi9SrWJ2G1Md-QEw7hdWtV_FM8ku17IXg_X2Ism0TRPskIFKNdy0d4X3MOXisYzDkSOfGMmKi_RZMzH0k"]
            WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: true, params: params, success: { (dataDict) in
                
                let jsonData = JSON(dataDict)
                
                if jsonData["code"] == 0{

                    let userDict = jsonData["data"]["user"].dictionaryObject
                    UserDefaults.standard.set(userDict , forKey: userUD)
                }
            })
        }else{
            let userDict:[String:Any] = UserDefaults.standard.object(forKey: userUD) as! [String : Any]
            userIconImageV.kf.setImage(with: URL(string: (userDict["photo"] as! String)))
            userDescriptionLab.text = userDict["description"] as? String
            userNameLab.text = (userDict["nickName"] as? String)
        }
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as PlayRecordTableCell
            cell.mainTitleLab.text = dataArray[indexPath.row]["title"]
            cell.iconImageV.image = UIImage(named: dataArray[indexPath.row]["titleImage"]!)
            return cell
        } else {
            let cell = tableV.wf_dequeueReusableCell(indexPath: indexPath) as MineTableCell
            cell.mainTitleLab.text = dataArray[indexPath.row]["title"]
            cell.iconImageV.image = UIImage(named: dataArray[indexPath.row]["titleImage"]!)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 55
        }else{
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            printCtm(indexPath.row)
        
        case 1: break
            
            
        case 2:
            printCtm(indexPath.row)
            
            let vc = MeCollectVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            printCtm(indexPath.row)
            
        case 4:
            printCtm(indexPath.row)
            
        case 5:
            printCtm(indexPath.row)
            
        case 6:
            printCtm(indexPath.row)
            
        default: break
            
        }
    }
   
}


