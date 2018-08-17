//
//  TitleTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/13.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import Kingfisher
class TitleTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var iconImageV: UIImageView!
    
    var model = TitleModel(){
        didSet{
            titleLab.text = model.name
            iconImageV.kf.setImage(with: URL(string: model.icon))
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
