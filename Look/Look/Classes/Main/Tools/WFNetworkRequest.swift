//
//  WFNetworkRequest.swift
//  News
//
//  Created by 王峰 on 2018/7/29.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

import Alamofire

private let NetworkRequestShareInstance = WFNetworkRequest()


class WFNetworkRequest: NSObject {

    class var sharedInstance: WFNetworkRequest {
        return NetworkRequestShareInstance
    }
}

extension WFNetworkRequest{
    
    
    /// 自定义网络请求
    ///
    /// - Parameters:
    ///   - url: 网址
    ///   - isPost: 是否为post请求 默认是
    ///   - params: 参数
    ///   - success: 成功回调
    ///   - failture: 失败回调
    func ToolRequest(url:String, isPost:Bool = true, params:[String:Any], success:@escaping(_ response :AnyObject)->(), failture:@escaping (_ error :Error)->()) -> (Void) {
        
        let method = isPost ? HTTPMethod.post:HTTPMethod.get
        
        Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
            if(dataResponse.result.isSuccess){
                success(dataResponse.result.value as AnyObject)
            }else{
                failture(dataResponse.result.error!)
            }
        }
    }
    
   
}



























