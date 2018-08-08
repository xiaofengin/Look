//
//  ConcernTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class ConcernTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var mainImageV: UIImageView!
    
    @IBOutlet weak var mainTitleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    var myConcern = MeCollectModel(){
        didSet{
            mainImageV.kf.setImage(with: URL(string: myConcern.cover))
            mainTitleLab.text = myConcern.title
            subTitleLab.text = (myConcern.publishTime/1000).convertString()+"|"+"\(myConcern.pn)"+"次播放"
            timeLab.text = myConcern.duration.convertVideoDuration()
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
