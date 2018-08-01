//
//  MineModel.swift
//  News
//
//  Created by 王峰 on 2018/7/30.
//  Copyright © 2018年 qq. All rights reserved.
//

import Foundation
import HandyJSON


struct MineModel:HandyJSON {
    var grey_text: String = ""
    var text: String = ""
    var url: String = ""
    var key: String = ""
    var tip_new: Int = 0
}

struct UserAuthInfo: HandyJSON {
    var auth_type: Int = 0
    var auth_info: String = ""
}
