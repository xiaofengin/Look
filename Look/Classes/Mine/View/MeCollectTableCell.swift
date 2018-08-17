//
//  MeCollectTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/5.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class MeCollectTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var videosImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    
    
    var meCollectModel = MeCollectModel(){
        didSet{
            videosImageV.kf.setImage(with: URL(string: meCollectModel.cover))
            subTitleLab.text = meCollectModel.title
            mainTitleLab.text = meCollectModel.user.nickName
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
