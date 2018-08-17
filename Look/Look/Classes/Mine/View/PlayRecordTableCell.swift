//
//  PlayRecordTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/3.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class PlayRecordTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
