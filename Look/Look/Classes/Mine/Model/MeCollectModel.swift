//
//  MeCollectModel.swift
//  Look
//
//  Created by 王峰 on 2018/8/5.
//  Copyright © 2018年 王峰. All rights reserved.
//

import Foundation
import HandyJSON

struct MeCollectModel:HandyJSON {
    var ln : Int = 0
    var isLike :Bool = false
    var isCollection :Bool = false
    var description : String = ""
    var videoId : String = ""
    var threshold : Int = 0
    var type :String = ""
    var title : String = ""
    var cover : String = ""
    var duration : Int = 0
    var tag : String = ""
    var st : String = ""
    var publishTime : Int = 0
    var docid : Int = 0
    var videoType : Int = 0
    var cn : Int = 0
    var pn : Int = 0
    var streams  = [Streams]()
    var user = User()
    
    
}
///数据流
struct Streams: HandyJSON {
    var quality : Int = 0
    var url : String = ""
    var duration : Int = 0
    var size : Int = 0
    var bitrate : Int = 0
    var width : Int = 0
    var height : Int = 0
    var fps : Int = 0
}
struct User:HandyJSON {
    var nickName : String = ""
    var description : String = ""
    var photo : String = ""
    var id : Int = 0
    var verify : Int = 0
    var fn : Int = 0
}
