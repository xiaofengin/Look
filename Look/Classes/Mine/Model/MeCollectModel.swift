//
//  MeCollectModel.swift
//  Look
//
//  Created by 王峰 on 2018/8/5.
//  Copyright © 2018年 王峰. All rights reserved.
//

import Foundation
import HandyJSON

///热点新闻
struct HotNewsModel:HandyJSON {
    var isLock : Int = 0
    var isTop : Int = 0
    var showType : Int = 0
    var lastId : Int = 0
    var video = MeCollectModel()
    var endTime:Int = 0
    var type :String = ""
    var isShowCover : Int = 0
}
//视频数据
struct MeCollectModel:HandyJSON {
    var ln : Int = 0
    var lnCount:String {
        return ln.convertString()
    }
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
    var publishTime :TimeInterval  = 0
    var docid : Int = 0
    var videoType : Int = 0
    var cn : Int = 0
    var pn : Int = 0
    var pnCount:String {
        return pn.convertString()
    }
    
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
    var vn : Int = 0
}
