//
//  Const.swift
//  News
//
//  Created by 王峰 on 2018/7/28.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

///系统宽度
let Kwidth = UIScreen.main.bounds.width
///系统高度
let Kheight = UIScreen.main.bounds.height

/// 服务器地址
//let BASE_URL = "http://lf.snssdk.com"
//let BASE_URL = "http://ib.snssdk.com"
let BASE_URL = "https://is.snssdk.com"

var startTime: String = ""




func setStatusBarBackgroundColor(color:UIColor) {
    let statusBarWindow: UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
    let statusBar: UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
        statusBar.backgroundColor = color
    }
    
}
