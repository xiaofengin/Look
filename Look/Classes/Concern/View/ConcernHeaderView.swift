//
//  ConcernHeaderView.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class ConcernHeaderView: UIView ,NibLoadable{
    
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var mainInageV: UIImageView!
    @IBOutlet weak var vipImageV: UIImageView!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var headBut: UIButton!
    @IBOutlet weak var hederViedoBut: UIButton!
    

    
    
    var userData = User(){
        didSet{
            userIconImageV.kf.setImage(with: URL(string: userData.photo))
            userIconImageV.layer.masksToBounds = true
            userIconImageV.layer.cornerRadius = 35/2
            if userData.verify == 0 {
                vipImageV.isHidden = true
            }
            mainTitleLab.text = userData.nickName
            subTitleLab.text = userData.description
        }
    }
    var myConcern = MeCollectModel(){
        didSet{
            mainInageV.kf.setImage(with: URL(string: myConcern.cover))
            titleLab.text = myConcern.title
            timeLab.text = myConcern.duration.convertVideoDuration()
        }
    }
    
}
