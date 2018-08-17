//
//  SmallVideoCollectionCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/11.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class SmallVideoCollectionCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var mainImageV: UIImageView!
    @IBOutlet weak var payerNumLab: UILabel!
    @IBOutlet weak var goodNumberLab: UILabel!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var closeBut: UIButton!
    
    var mySmallVideoData = HotNewsModel(){
        didSet{
            mainImageV.kf.setImage(with: URL(string: mySmallVideoData.video.cover))
            payerNumLab.text = mySmallVideoData.video.pnCount+"次播放"
            goodNumberLab.text = mySmallVideoData.video.lnCount+"赞"
            mainTitleLab.text = mySmallVideoData.video.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
