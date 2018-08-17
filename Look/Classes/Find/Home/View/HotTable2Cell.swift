//
//  HotTable2Cell.swift
//  Look
//
//  Created by 王峰 on 2018/8/11.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class HotTable2Cell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var mainImageV: UIImageView!
    
    var hotNewsModel = HotNewsModel(){
        didSet{
            mainImageV.kf.setImage(with: URL(string: hotNewsModel.video.cover))
            mainTitleLab.text = hotNewsModel.video.title
            subTitleLab.text = hotNewsModel.video.user.nickName+" "+(hotNewsModel.video.publishTime/1000).convertString()
            timeLab.text = hotNewsModel.video.duration.convertVideoDuration()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
