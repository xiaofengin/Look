//
//  WFTool.swift
//  Look
//
//  Created by 王峰 on 2018/8/1.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

private let WFToolInstance = WFTool()

class WFTool: NSObject {
    class var sharedInstance: WFTool {
        return WFToolInstance
    }
}

extension WFTool{
    func getStartTime() {
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = Date().timeIntervalSince1970
        startTime = "\(timeInterval)"
        print(startTime)
    }
}
