
//
//  ContentModel.swift
//  Look
//
//  Created by 王峰 on 2018/8/19.
//  Copyright © 2018年 王峰. All rights reserved.
//

import Foundation
import HandyJSON

struct ContentModel:HandyJSON {
    
    var content : String = ""
    var createTime : TimeInterval = 0
    var user : UserModel = UserModel()
    var cellHeight : Int = 0
}
