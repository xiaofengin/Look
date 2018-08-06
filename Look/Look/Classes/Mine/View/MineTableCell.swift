//
//  MineTableCell.swift
//  News
//
//  Created by 王峰 on 2018/7/30.
//  Copyright © 2018年 qq. All rights reserved.
//


import UIKit

class MineTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var subtitleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}












