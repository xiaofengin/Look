//
//  UserModel.swift
//  Look
//
//  Created by 王峰 on 2018/8/3.
//  Copyright © 2018年 王峰. All rights reserved.
//

import Foundation
import HandyJSON

struct UserModel: HandyJSON {
    var description :String = ""
    var type :String = ""
    var birthday :Int = 0
    var shareTitle :String = ""
    var shareUrl :String = ""
    var id :Int = 0
    var nickName :String = ""
    var photo :String = ""

}
