//
//  SmallVideoVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import SwiftyJSON

class SmallVideoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var collectionV: UICollectionView!
    

    let pageNo = 1
    var smallVideoArray = [HotNewsModel]()
    var isLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionV.wf_registerCell(cell: SmallVideoCollectionCell.self)
       
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: Kwidth/2-1, height: Kwidth/2*570/320)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionV.collectionViewLayout = layout
    
        ///http://api.klm123.com/channel/getListById/version/6?src=1000&t=1534057723.187437&channelId=100&pageNo=1&pageSize=10&rc=1
    
    }
    func smallVideoRequset()  {
        if isLoad {
            NetworkRequest(page: pageNo)
            isLoad = false
        }
    }

    func NetworkRequest(page: Int) {
        ///获取新闻信息接口
        
        let url = "http://api.klm123.com/channel/getListById/version/6?src=1000&t=\((UserDefaults.standard.object(forKey: startTimeUD) as! String))&channelId=100&pageNo=\(page)&pageSize=10&rc=1"
        
        WFNetworkRequest.sharedInstance.ToolRequest(url: url, isPost: false, params: nil, success: { (dataDict) in
            
            let jsonData = JSON(dataDict)
            printCtm(jsonData)
            if jsonData["code"] == 0{
                
                if let collectArray = jsonData["data"]["items"].arrayObject{
                    
                    self.smallVideoArray = collectArray.compactMap({ HotNewsModel.deserialize(from: $0 as? Dictionary) })
                    
                    self.collectionV.reloadData()
                }
                
            }
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return smallVideoArray.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.wf_dequeueReusableCell(indexPath: indexPath) as SmallVideoCollectionCell
        cell.mySmallVideoData = smallVideoArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = SmallVideoInfoVC()
        vc.hidesBottomBarWhenPushed = true
        vc.originalIndex = indexPath.row;
        vc.smallVideoArray = smallVideoArray
        navigationController?.pushViewController(vc, animated: true)
    }
}
