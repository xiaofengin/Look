//
//  CommentTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/19.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class CommentTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var userNameLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    
    var model = ContentModel(){
        didSet{
            userIconImageV.kf.setImage(with: URL(string: model.user.photo))
            userNameLab.text = model.user.nickName
            contentLab.text = model.content
            timeLab.text = model.createTime.convertString()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        userIconImageV.layer.masksToBounds = true
        userIconImageV.layer.cornerRadius = 35/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
