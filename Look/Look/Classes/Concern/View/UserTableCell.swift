//
//  UserTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class UserTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var mainImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var durationTimeLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var commentBut: UIButton!
    @IBOutlet weak var praiseBut: UIButton!
    @IBOutlet weak var playProgress: UIProgressView!
    
    var myConcern = MeCollectModel(){
        didSet{
            mainImageV.kf.setImage(with: URL(string: myConcern.cover))
            mainTitleLab.text = myConcern.title
            durationTimeLab.text =  myConcern.duration.convertVideoDuration()
            timeLab.text = myConcern.duration.convertString()
            praiseBut.setTitle("\(myConcern.ln)", for: .normal)
            if myConcern.cn > 0 {
                commentBut.setTitle("\(myConcern.cn)", for: .normal)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
