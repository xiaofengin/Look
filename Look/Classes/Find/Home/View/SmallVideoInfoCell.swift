//
//  SmallVideoInfoCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/24.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class SmallVideoInfoCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var shareBut: UIButton!
    @IBOutlet weak var commentBut: UIButton!
    @IBOutlet weak var heartBut: UIButton!
    @IBOutlet weak var mainImageV: UIImageView!
    
    var mySmallVideoData = HotNewsModel(){
        didSet{
            mainImageV.kf.setImage(with: URL(string: mySmallVideoData.video.cover))
            commentBut.setTitle(mySmallVideoData.video.cn.convertString(), for: .normal)
            heartBut.setTitle(mySmallVideoData.video.pn.convertString(), for: .normal)
            titleLab.text = mySmallVideoData.video.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
