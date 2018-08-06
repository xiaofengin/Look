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

let startTimeUD = "startTime"
let userUD = "user"

func setStatusBarBackgroundColor(color:UIColor) {
    let statusBarWindow: UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
    let statusBar: UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
        statusBar.backgroundColor = color
    }
    
}


/// 获取存储的 UserDefaults
///
/// - Parameter keyStr: 关键字
/// - Returns: 获得存储的值
func getUserDefaults(keyStr:String) -> String {
    return UserDefaults.standard.object(forKey: keyStr) as! String
}
/// 自定义 log
/// - Parameters:
///   - message: 要打印的内容
///   - fileName: 文件名 有初始值 可不用传
///   - methodName: 方法名
///   - lineString: 行号
// #if DEBUG #endif
// swift 中没有宏定义 可手动添加 building setting -> 搜索 "custom flag" -> DEBUG 下添加 -D DEBUG
func printCtm <T> (_ message : T ,fileName : String = #file ,methodName:String = #function ,lineString : Int = #line)  {
    #if DEBUG
    let file = (fileName as NSString).pathComponents.last?.components(separatedBy: ".").first
    print("\(file ?? ""):\(methodName)[\(lineString)]:\(message)")
    #endif
}


/// JSONString转换为字典
///
/// - Parameter jsonString: <#jsonString description#>
/// - Returns: <#return value description#>
func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
    
    
}


/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
}


