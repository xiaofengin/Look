//
//  BMPlayerCustomControlView.swift
//  News
//
//  Created by 杨蒙 on 2018/1/16.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import BMPlayer

class SmallVideoPlayerCustomView: BMPlayerControlView {

    override func customizeUIComponents() {
        BMPlayerConf.topBarShowInCase = .none
        playButton.removeFromSuperview()
        currentTimeLabel.removeFromSuperview()
        totalTimeLabel.removeFromSuperview()
        timeSlider.removeFromSuperview()
        fullscreenButton.removeFromSuperview()
        progressView.removeFromSuperview()
    }

}
