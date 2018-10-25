//
//  UserTableCell.swift
//  Look
//
//  Created by 王峰 on 2018/8/6.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import RxSwift
class UserTableCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var mainImageV: UIImageView!
    @IBOutlet weak var mainTitleLab: UILabel!
    @IBOutlet weak var durationTimeLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var commentBut: UIButton!
    @IBOutlet weak var praiseBut: UIButton!
    @IBOutlet weak var playProgress: UIProgressView!
    
    @IBOutlet weak var shareBut: UIButton!
    @IBOutlet weak var weixinView: UIView!
    @IBOutlet weak var weixinViewToBottom: NSLayoutConstraint!
    
    @IBOutlet weak var usericonView: UIView!
    @IBOutlet weak var userIconImageV: UIImageView!
    @IBOutlet weak var VIPImageV: UIImageView!
    @IBOutlet weak var attentionBut: UIButton!
    @IBOutlet weak var weixinWeight: NSLayoutConstraint!
    
    @IBOutlet weak var playerBut: UIButton!
    @IBOutlet weak var userBut: UIButton!
    
    var disposeBag = DisposeBag()
    
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    var myConcern = MeCollectModel(){
        didSet{
            playerBut.kf.setImage(with: URL(string: myConcern.cover), for: .normal)
            mainTitleLab.text = myConcern.title
            durationTimeLab.text =  myConcern.duration.convertVideoDuration()
            timeLab.text = myConcern.user.nickName//myConcern.duration.convertString()
            praiseBut.setTitle("\(myConcern.ln)", for: .normal)
            if myConcern.cn > 0 {
                commentBut.setTitle("\(myConcern.cn)", for: .normal)
            }
            userIconImageV.kf.setImage(with: URL(string: myConcern.user.photo))
            if myConcern.user.verify == 1 {
                VIPImageV.isHidden = false
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        userIconImageV.layer.masksToBounds = true
        userIconImageV.layer.cornerRadius = 15
        
        usericonView.layer.masksToBounds = true
        usericonView.layer.cornerRadius = 16
    }

    ///未播放视频
    func showSubviews()  {
        mainTitleLab.isHidden = false
        mainImageV.isHidden = false
        durationTimeLab.isHidden = false
        weixinViewToBottom.constant = 40
        timeLab.isHidden = false
        attentionBut.isHidden = true
        shareBut.isHidden = false
        weixinView.isHidden = true
        weixinWeight.constant = 30
    }
    ///播放视频
    func hiddenSubviews()  {
        mainTitleLab.isHidden = true
        mainImageV.isHidden = true
        durationTimeLab.isHidden = true
        weixinViewToBottom.constant = 8
        timeLab.isHidden = true
        attentionBut.isHidden = false
        shareBut.isHidden = true
        weixinView.isHidden = false
        weixinWeight.constant = 60
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
